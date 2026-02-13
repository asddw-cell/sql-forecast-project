/* 
    PURPOSE OF THIS SCRIPT
    ----------------------
    Ensure that for every:

        ForecastType
        SalesChannel
        ForecastCustomer
        Year
        MonthNum
        BusinessUnit
        Brand
        ItemNo
        PriceType
        Price

    there is a row in tblForecastData_US.

    If a specific Month + Price combination does NOT exist,
    we create a new row with:

        Quantity = 0

    In other words:
    We are making Price part of the business key and 
    ensuring that every price variant exists for every month.
*/


/* =============================
   1️⃣ Parameter Setup
   ============================= */

DECLARE @StartDate date = '2026-01-01';     -- First month to evaluate
DECLARE @Months int = 12;                  -- Number of months to generate

DECLARE @ForecastType int = 1;
DECLARE @PriceType int = 1;
DECLARE @BusinessUnit int = 1;

/* Optional filters for testing one specific combo */
DECLARE @ForecastCustomer nvarchar(20) = 'US_CA_WAL';
DECLARE @ItemNo nvarchar(20) = '108202.104';

/* Calculate end boundary (exclusive) */
DECLARE @EndDate date = DATEADD(MONTH, @Months, @StartDate);



/* =============================
   2️⃣ Generate a List of Months
   =============================

   This creates a row for each month:

        2026-01-01
        2026-02-01
        ...
        2026-12-01

   We will later CROSS JOIN this to price variants.
*/

WITH MonthSeries AS
(
    SELECT @StartDate AS MonthStart

    UNION ALL

    SELECT DATEADD(MONTH, 1, MonthStart)
    FROM MonthSeries
    WHERE DATEADD(MONTH, 1, MonthStart) < @EndDate
),



/* =============================
   3️⃣ Get Distinct Price Variants
   =============================

   This pulls the DISTINCT combinations of:

        SalesChannel
        ForecastCustomer
        Brand
        ItemNo
        Price

   from the TARGET table.

   Important:
   We include Price here because Price is part of the uniqueness rule.
*/

PriceVariants AS
(
    SELECT DISTINCT
        t.ForecastType,
        t.SalesChannel,
        t.ForecastCustomer,
        ISNULL(t.BusinessUnit, @BusinessUnit) AS BusinessUnit,
        t.Brand,
        t.ItemNo,
        t.PriceType,
        t.Price
    FROM dbo.tblForecastData_US t
    WHERE t.ForecastType = @ForecastType
      AND t.PriceType    = @PriceType
      AND ISNULL(t.BusinessUnit, @BusinessUnit) = @BusinessUnit
      AND t.Price IS NOT NULL

      /* Limit price variants to the same time window */
      AND DATEFROMPARTS(t.[Year], t.MonthNum, 1) >= @StartDate
      AND DATEFROMPARTS(t.[Year], t.MonthNum, 1) <  @EndDate

      /* Optional test filters */
      AND t.ForecastCustomer = @ForecastCustomer
      AND t.ItemNo = @ItemNo
)



/* =============================
   4️⃣ Insert Missing Rows
   =============================

   We CROSS JOIN:

        PriceVariants  ×  MonthSeries

   That creates every possible:

        (Price variant × Month)

   Then we use NOT EXISTS to check whether that
   specific combination already exists in the table.

   If it does NOT exist → we insert it.
*/

INSERT INTO dbo.tblForecastData_US
(
    ForecastType,
    SalesChannel,
    ForecastCustomer,
    [Year],
    MonthNum,
    BusinessUnit,
    Brand,
    ItemNo,
    Quantity,
    Price,
    PriceType
)
SELECT
    pv.ForecastType,
    pv.SalesChannel,
    pv.ForecastCustomer,
    YEAR(ms.MonthStart)  AS [Year],
    MONTH(ms.MonthStart) AS MonthNum,
    pv.BusinessUnit,
    pv.Brand,
    pv.ItemNo,

    /* New rows are created with zero quantity */
    CAST(0 AS decimal(38,20)) AS Quantity,

    /* Price comes from the price variant */
    CAST(pv.Price AS decimal(38,20)) AS Price,

    pv.PriceType

FROM PriceVariants pv
CROSS JOIN MonthSeries ms

/* =============================
   5️⃣ Only Insert Missing Rows
   =============================

   NOT EXISTS checks whether the exact same
   key combination already exists.

   If it exists → do NOT insert.
   If it does NOT exist → insert it.
*/

WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.tblForecastData_US t
    WHERE t.ForecastType = pv.ForecastType
      AND t.PriceType    = pv.PriceType
      AND t.[Year]       = YEAR(ms.MonthStart)
      AND t.MonthNum     = MONTH(ms.MonthStart)
      AND ISNULL(t.BusinessUnit, @BusinessUnit) = pv.BusinessUnit

      /* 
         We use LTRIM/RTRIM + COLLATE to avoid:

         - Trailing space mismatches
         - Collation conflicts between databases
      */
      AND LTRIM(RTRIM(t.SalesChannel))     
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(pv.SalesChannel))     
            COLLATE DATABASE_DEFAULT

      AND LTRIM(RTRIM(t.ForecastCustomer)) 
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(pv.ForecastCustomer)) 
            COLLATE DATABASE_DEFAULT

      AND LTRIM(RTRIM(t.Brand))            
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(pv.Brand))            
            COLLATE DATABASE_DEFAULT

      AND LTRIM(RTRIM(t.ItemNo))           
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(pv.ItemNo))           
            COLLATE DATABASE_DEFAULT

      /* Price is part of the uniqueness rule */
      AND t.Price = pv.Price
)

OPTION (MAXRECURSION 2000);
