# sql-forecast-project
Building a solution allowing end users to maintain a product forecast via an elegant frontend connected to a SQL Server backend. The solution will use MS SQL Server 2019 Std, MS Excel and SQL Spreads Addin for Excel.

Phase 1 limitations:
  1.  The frontend will not show actual quantities and values.
  2.  The frontend will not value individual months, only the full years.
  3.  Months cannot be locked for editing.

Backend preparation.

  1. init_database.sql to create the database.
  2. create_dimtables.sql to create the dimensional tables.
  3. create_tblForecastData_US.sql to create the transactional table for US.
  4. create_tblForecastData_UK.sql to create the transactional table for UK.
