
-- Portfolio Project
--Cleaning Data in SQL


Select*
From PortfolioProject.dbo.NashvilleHousing


-- Standardise Date Format


Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- The above didn't work so trying a different approach


Select SaleDateConverted2, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add SaleDateConverted2 Date;

Update NashvilleHousing
SET SaleDateConverted2 = CONVERT(Date,SaleDate)


-- Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null



-- Breaking Address Into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add Property_Street_Address Nvarchar(255)

UPDATE NashvilleHousing
SET Property_Street_Address = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add Property_City Nvarchar(255)

UPDATE NashvilleHousing
SET Property_City = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME (REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME (REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME (REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add Owner_Street_Address Nvarchar(255)

UPDATE NashvilleHousing
SET Owner_Street_Address = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add Owner_City Nvarchar(255)

UPDATE NashvilleHousing
SET Owner_City = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add Owner_State Nvarchar(255)

UPDATE NashvilleHousing
SET Owner_State = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 1)

Select *
FROM PortfolioProject.DBO.NashvilleHousing


-- Change Y and N to Yes and No in "Sold As Vacant" Field

Select Distinct (SoldAsVacant), Count (SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
	CASE When SoldAsVacant = 'N' Then 'No'
		 When SoldAsVacant = 'Y' Then 'Yes'
		ELSE SoldAsVacant
	END
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'N' Then 'No'
		 When SoldAsVacant = 'Y' Then 'Yes'
		ELSE SoldAsVacant
	END

	

-- Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() Over (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER By
					UniqueId
					) row_num
From PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress

Select *
From PortfolioProject.dbo.NashvilleHousing


-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate, SaleDateConverted, SaleDateConverted1




