SELECT *
FROM [dbo].[Nashville]

-- Standardize Date format (take off hours).

SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM [dbo].[Nashville]

ALTER TABLE [dbo].[Nashville]    -- Create a new column with date constraint
ADD SaleDateConverted Date

UPDATE [dbo].[Nashville]
SET SaleDateConverted = CONVERT(DATE, SaleDate)     -- Date format without hours

-----------------------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address Data

SELECT PropertyAddress
FROM [dbo].[Nashville]

SELECT *
FROM [dbo].[Nashville]
WHERE PropertyAddress IS NULL        -- We have 29 null fields

SELECT ParcelID, PropertyAddress
FROM [dbo].[Nashville]
ORDER BY ParcelID		             -- We see that the PropertyAddress are identical when the ParcelID are.


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress         -- So we want to take those that have the same id but not the same row.
FROM [dbo].[Nashville] as a 
INNER JOIN [dbo].[Nashville] as b
	ON a.ParcelID = b.ParcelID        
	AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) --create a new column for everyone in b
FROM [dbo].[Nashville] as a 
INNER JOIN [dbo].[Nashville] as b
	ON a.ParcelID = b.ParcelID        
	AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) -- Activate this column if...
FROM [dbo].[Nashville] as a 
INNER JOIN [dbo].[Nashville] as b
	ON a.ParcelID = b.ParcelID                        -- ...The null is in this array
	AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL

-----------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual column

SELECT PropertyAddress
FROM [dbo].[Nashville]

SELECT  PropertyAddress, 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address, -- separate the address from the city (-1 remove the comma).
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City  -- separate city from address (+ 1 remove the comma).
FROM [dbo].[Nashville]


ALTER TABLE [dbo].[Nashville]
ADD Split_Address nvarchar(255);         

ALTER TABLE [dbo].[Nashville]
ADD City nvarchar(255);

UPDATE [dbo].[Nashville]
SET Split_Address =   SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

UPDATE [dbo].[Nashville]
SET City =   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-----------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No for 'Sold as Vacant' column

SELECT DISTINCT SoldAsVacant
FROM [dbo].[Nashville]               -- we can see that we have ('Yes', 'No', 'Y', 'N')


SELECT SoldAsVacant, 
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'     -- If it's 'Y', then...
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END  update_col
FROM [dbo].[Nashville]


UPDATE [dbo].[Nashville] 
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'YES'     
					WHEN SoldAsVacant = 'N' THEN 'NO'
					ELSE SoldAsVacant
					END  

					
-----------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused column 

ALTER TABLE [dbo].[Nashville]
DROP COLUMN  PropertyAddress, OwnerName

ALTER TABLE [dbo].[Nashville]       -- Delete the original SaleDate column
DROP COLUMN SaleDate