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
