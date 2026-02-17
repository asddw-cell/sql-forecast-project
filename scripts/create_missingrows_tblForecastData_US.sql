
/*
==============================================================================
PURPOSE OF THIS SCRIPT
==============================================================================

Business Rule:
--------------
For every existing combination of:

    ForecastType
    SalesChannel
    ForecastCustomer
    Year
    Brand
    ItemNo
    PriceType
    Price

we must ensure that ALL 12 months (1–12) exist.

If a specific Month + Price combination does NOT exist,
we create a new row with:

    Quantity = 0

IMPORTANT:
----------
We ONLY generate rows for years that already exist
for that item/customer/price combination.

Example:
- If an item exists in 2026 and 2027 → fill both years.
- If it exists only in 2026 → do NOT create 2027 rows.

Price IS part of the uniqueness rule.
*/


/* =========================================================
   1️⃣ Parameter Setup
   ========================================================= */

DECLARE @ForecastType int = 1;
DECLARE @PriceType int = 1;
DECLARE @OpenDate date = DATEADD(MONTH, 3, GETDATE());
/* Optional filters for testing a single combination.
   Remove these filters to run for all data. */
DECLARE @ForecastCustomer nvarchar(20) = 'US_CA_WAL';
DECLARE @ItemNo nvarchar(20) = '108202.104';



/* =========================================================
   2️⃣ Create a Static List of Months (1–12)
   =========================================================

   Instead of generating dates, we simply create a table
   containing the numbers 1 through 12.

   This represents all months in a year.
*/

WITH Months AS
(
    SELECT v.MonthNum
    FROM (VALUES 
        (1),(2),(3),(4),(5),(6),
        (7),(8),(9),(10),(11),(12)
    ) v(MonthNum)
),



/* =========================================================
   3️⃣ Get Existing Year + Price Variants
   =========================================================

   This pulls DISTINCT combinations from the TARGET table.

   We include:
       - Year
       - Price

   Because:
       • We only want to generate rows for years that already exist
       • Price is part of the business key

   DISTINCT ensures we don’t accidentally multiply rows.
*/

YearPriceVariants AS
(
    SELECT DISTINCT
        t.ForecastType,
        t.SalesChannel,
        t.ForecastCustomer,
        t.Brand,
        t.ItemNo,
        t.PriceType,
        t.Price,
        t.[Year]
    FROM dbo.tblForecastData_US t
    WHERE t.ForecastType = @ForecastType
      AND t.PriceType    = @PriceType
      AND t.Price IS NOT NULL

      /* Optional test filters */
      AND t.ForecastCustomer = @ForecastCustomer
      AND t.ItemNo = @ItemNo
),



/* =========================================================
   4️⃣ Expand Each Year into 12 Months
   =========================================================

   CROSS JOIN multiplies rows.

   If we have:
       2 price variants
       1 year
       12 months

   CROSS JOIN produces:
       2 × 12 = 24 possible rows

   This gives us every Month that SHOULD exist.
*/

NeededRows AS
(
    SELECT
        ypv.ForecastType,
        ypv.SalesChannel,
        ypv.ForecastCustomer,
        ypv.Brand,
        ypv.ItemNo,
        ypv.PriceType,
        ypv.Price,
        ypv.[Year],
        m.MonthNum
    FROM YearPriceVariants ypv
    CROSS JOIN Months m
)



/* =========================================================
   5️⃣ Insert Only Missing Month Rows
   =========================================================

   NOT EXISTS ensures we only insert rows that are missing.

   If a row already exists → skip it.
   If it does NOT exist → insert it with Quantity = 0.
*/

INSERT INTO dbo.tblForecastData_US
(
    ForecastType,
    SalesChannel,
    ForecastCustomer,
    [Year],
    MonthNum,
    Brand,
    ItemNo,
    Quantity,
    Price,
    PriceType,
    OpenDateKey
)
SELECT
    n.ForecastType,
    n.SalesChannel,
    n.ForecastCustomer,
    n.[Year],
    n.MonthNum,
    n.Brand,
    n.ItemNo,

    /* New rows are created with zero quantity */
    CAST(0 AS decimal(38,20)) AS Quantity,

    /* Price is preserved from the variant */
    CAST(n.Price AS decimal(38,20)) AS Price,

    n.PriceType,
    YEAR(@OpenDate) * 100 +MONTH(@OpenDate)

FROM NeededRows n
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.tblForecastData_US t
    WHERE t.ForecastType = n.ForecastType
      AND t.PriceType    = n.PriceType
      AND t.[Year]       = n.[Year]
      AND t.MonthNum     = n.MonthNum

      /*
         We use LTRIM/RTRIM + COLLATE to prevent:

         • Collation conflicts between databases
         • Trailing space mismatches
      */
      AND LTRIM(RTRIM(t.SalesChannel))     
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(n.SalesChannel))     
            COLLATE DATABASE_DEFAULT

      AND LTRIM(RTRIM(t.ForecastCustomer)) 
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(n.ForecastCustomer)) 
            COLLATE DATABASE_DEFAULT

      AND LTRIM(RTRIM(t.Brand))            
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(n.Brand))            
            COLLATE DATABASE_DEFAULT

      AND LTRIM(RTRIM(t.ItemNo))           
            COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(n.ItemNo))           
            COLLATE DATABASE_DEFAULT

      /* Price is part of the uniqueness rule */
      AND t.Price = n.Price
);
