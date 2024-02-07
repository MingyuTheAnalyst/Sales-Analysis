# Sales Management Project

<img width="600" alt="salesproject" src="https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/41ae37f4-d0d3-4e8a-9b04-6e9f2b6c0bfa">

## Table of Contents

 - [Project Overview](#project-overview)
 - [Data Sources](#data-sources)
 - [Tools](#tools)
 - [Requirement](#requirement)
 - [Data Cleaning & Transformation](#data-cleaning-and-transformation)
 - [Data Visualization](#data-visualization)

### Project Overview

- According to the requirements set by the virtual manager Steven, which involved enhancing internet sales reporting from 2022 to 2024 by transitioning from static reports to dynamic, visual dashboards, I carried out a project to clean Sales Data with SQL and create data modeling and a dashboard with Power BI.

### Data Sources

- This is AdventureWorks sample databases which is free database provided by Microsoft. [Link](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)
- The sales budget, originally made by [Ali Ahmad](https://topmate.io/aliahmad), was changed by me to update the "Year" so it would match my project

### Tools

- SQL Server - Data Cleaning, Transformation
- Power BI - Data Modeling, Creating Dashboard


### Requirement

Focus Areas:
 - Quantities sold of specific products.
 - Identification of clients purchasing these products.
 - Analysis of sales trends over time.

Comparison Against Budget:
 - Sales figures to be measured against the 2021 budget for performance comparison.
 - Steven has provided a spreadsheet with the budget details.


### Data Cleaning and Transformation

In the initial data preparation phase, we performed the following tasks:
1. Restore the downloaded database to SQL Server.
2. Data loading and inspection.
3. Trasforming and extract the data.

- DIM_Calendar table
  
  ![2-Calendar](https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/0ffdf455-6e95-45bd-8169-69e390ffb0d4)
  
  ```sql
  --Cleaned DIM_DateTable --
  SELECT 
    [DateKey], 
    [FullDateAlternateKey] AS Date, 
    --,[DayNumberOfWeek]
    [EnglishDayNameOfWeek] AS Day, 
    --,[SpanishDayNameOfWeek]
    --,[FrenchDayNameOfWeek]
    --,[DayNumberOfMonth]
    --,[DayNumberOfYear]
    [WeekNumberOfYear] AS WeekNo, 
    [EnglishMonthName] AS Month, 
    LEFT([EnglishMonthName], 3) AS MonthShort, 
    --,[SpanishMonthName]
    --,[FrenchMonthName]
    [MonthNumberOfYear] AS MonthNo, 
    [CalendarQuarter] AS Quarter, 
    [CalendarYear] As Year 
    --,[CalendarSemester]
    --,[FiscalQuarter]
    --,[FiscalYear]
    --,[FiscalSemester]
  FROM 
    [AdventureWorksDW2022].[dbo].[DimDate]
    WHERE CalendarYear >= 2022
  ```

- DIM_Customer table
  
  ![3-Customer](https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/eecc8a46-6512-4d2b-b602-0df46e19ca29)
  
  ```sql
  -- Cleaned DIM_Customers Table --
  SELECT 
    c.CustomerKey AS [Customer Key] 
    --,[GeographyKey]
    --,[CustomerAlternateKey]
    --,[Title]
    , 
    c.FirstName AS [First Name] 
    --,[MiddleName]
    , 
    c.LastName AS [Last Name], 
    c.FirstName + ' ' + [LastName] AS [Full Name] 
    --  ,[NameStyle]
    --  ,[BirthDate]
    --  ,[MaritalStatus]
    --  ,[Suffix]
    , 
    CASE c.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' ELSE 'Other' END AS [Gender] 
    --  ,[EmailAddress]
    --  ,[YearlyIncome]
    --  ,[TotalChildren]
    --  ,[NumberChildrenAtHome]
    --  ,[EnglishEducation]
    --  ,[SpanishEducation]
    --  ,[FrenchEducation]
    --  ,[EnglishOccupation]
    --  ,[SpanishOccupation]
    --  ,[FrenchOccupation]
    --  ,[HouseOwnerFlag]
    --  ,[NumberCarsOwned]
    --  ,[AddressLine1]
    --  ,[AddressLine2]
    --  ,[Phone]
    , 
    c.DateFirstPurchase AS [DateFirstPurchase] 
    --  ,[CommuteDistance]
    , 
    g.City AS [Customer City] -- Joined in Customer City from DimGeography Table
  FROM 
    [AdventureWorksDW2022].[dbo].[DimCustomer] AS c 
    LEFT JOIN DimGeography AS g ON g.GeographyKey = c.GeographyKey 
  ORDER BY 
    [Customer Key] ASC -- Ordered List by Customer Key
  ```

- DIM_Product table

  ![4-Products](https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/648f5219-2d30-4ff2-aa5e-0a8c80a1af84)

  ```sql
  -- Cleaned DIM Product Table --
  SELECT 
    p.[ProductKey], 
    p.[ProductAlternateKey] AS ProductItemCode, 
    --      ,[ProductSubcategoryKey]
    --      ,[WeightUnitMeasureCode]
    --      ,[SizeUnitMeasureCode]
    p.[EnglishProductName] AS [Product Name], 
    ps.EnglishProductSubcategoryName AS [Sub Category], 
    -- Joined in from Sub Category Table
    pc.EnglishProductCategoryName AS [Product Category], 
    -- Joined in from Category Table
    --      ,[SpanishProductName]
    --      ,[FrenchProductName]
    --      ,[StandardCost]
    --      ,[FinishedGoodsFlag]
    p.[Color] AS [Product Color], 
    --      ,[SafetyStockLevel]
    --      ,[ReorderPoint]
    --      ,[ListPrice]
    p.[Size] AS [Product Size], 
    --      ,[SizeRange]
    --      ,[Weight]
    --      ,[DaysToManufacture]
    p.[ProductLine] AS [Product Line], 
    --      ,[DealerPrice]
    --      ,[Class]
    --      ,[Style]
    p.[ModelName] AS [Product Model Name], 
    --      ,[LargePhoto]
    p.[EnglishDescription] AS [Product Description], 
    --      ,[FrenchDescription]
    --      ,[ChineseDescription]
    --      ,[ArabicDescription]
    --      ,[HebrewDescription]
    --      ,[ThaiDescription]
    --      ,[GermanDescription]
    --      ,[JapaneseDescription]
    --      ,[TurkishDescription]
    --      ,[StartDate]
    --      ,[EndDate]
    ISNULL (p.Status, 'Outdated') AS [Product Status] 
  FROM 
    [AdventureWorksDW2022].[dbo].[DimProduct] as p 
    LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
    LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
  ```

- FACT_InternetSales table

  ![5-internetSales](https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/31844aa0-0521-41d0-9699-85fc631293a8)
  
```sql
SELECT TOP (1000) [ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
      ,[CustomerKey]
--      ,[PromotionKey]
--      ,[CurrencyKey]
--      ,[SalesTerritoryKey]
      ,[SalesOrderNumber]
--      ,[SalesOrderLineNumber]
--      ,[RevisionNumber]
--      ,[OrderQuantity]
--      ,[UnitPrice]
--      ,[ExtendedAmount]
--      ,[UnitPriceDiscountPct]
--      ,[DiscountAmount]
--      ,[ProductStandardCost]
--      ,[TotalProductCost]
      ,[SalesAmount]
--      ,[TaxAmt]
--      ,[Freight]
--      ,[CarrierTrackingNumber]
--      ,[CustomerPONumber]
--      ,[OrderDate]
--      ,[DueDate]
--      ,[ShipDate]
  FROM [AdventureWorksDW2022].[dbo].[FactInternetSales]
  WHERE
	LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) - 2   -- Ensure we always only bring two years of date from extraction.
  ORDER BY OrderDateKey ASC
```





### Data Visualization

 - [Click to download Dashboard Power BI file](https://github.com/MingyuTheAnalyst/Sales-Management-Project/raw/main/SalesDashboard.pbix)
   
 - Import all of extracted data(.csv) to Power BI and make a relationship between keys.

	<img width="600" alt="Data Modeling" src="https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/b21dcca2-37d2-4387-93b3-bdd3e0d0bb6d">


 - Creating Dashboard

	![SalesOverview](https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/df229e1b-5a30-4dcf-982a-b0aa1398ecd3)
	
	![customerdetail1](https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/a6bd535b-fb7c-4ae2-9eae-5b3feffb9f50)
	
 	![productdetail1](https://github.com/MingyuTheAnalyst/Sales-Management-Project/assets/88122148/b192cc34-59a2-4614-837d-07a8cc7cfbfb)



