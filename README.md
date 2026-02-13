# sql-forecast-project
Building a solution allowing end users to maintain a product forecast via an elegant frontend connected to a SQL Server backend. The solution will use MS SQL Server 2019 Std at the backend with MS Excel macro enabled workbooks and SQL Spreads Addin for Excel to maintain the data.

## Phase 1 limitations:
  1.  The frontend will not show actual quantities and values.
  2.  The frontend will not value individual months, only the full years.
  3.  Months cannot be locked for editing.

## Backend preparation:

  1.  [init_database.sql to create the database](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/init_database.sql)
  2.  [create_dimtables.sql to create the dimensional tables](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/create_dimtables.sql)
  3.  [create_proc_Insert_tblBrand.sql to create the stored procedure to insert data to tblBrand](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/create_proc_Insert_tblBrand.sql)

### UK environment:
  
  1.  [create_tblForecastData_UK.sql to create the transactional table for UK](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/create_tblForecastData_UK.sql)
  2.  [import_ForecastCustomer_UK.sql to populate tblForecastCustomer_UK with initial data](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/import_ForecastCustomer_UK.sql)
  3.  [create_proc_Insert_tblItem_UK.sql to create the stored procedure to insert data to tblItem_UK](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/create_proc_Insert_tblItem_UK.sql)

### US environment:

  1.  [create_tblForecastData_US.sql to create the transactional table for US](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/create_tblForecastData_US.sql)
  2.  [import_ForecastCustomer_US.sql to populate tblForecastCustomer_US with initial data](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/import_ForecastCustomer_US.sql)
  3.  [create_proc_Insert_tblItem_US.sql to create the stored procedure to insert data to tblItem_US](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/create_proc_Insert_tblItem_US.sql)

## Forecast data imports.

### UK

  1.  

### US

  1.  [import_ForecastData_US.sql to populate tblForecastData_US with initial data](https://github.com/asddw-cell/sql-forecast-project/tree/main/scripts/import_ForecastData_US.sql)
