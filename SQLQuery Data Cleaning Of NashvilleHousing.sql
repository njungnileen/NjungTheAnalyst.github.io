

/*
Cleaning in SQL
*/

Select * 
From PorfolioProject.dbo.NashvilleHousing

--Sale Dates Format

Select SaleDateConverted , CONVERT(Date, SaleDate) 
From PorfolioProject.dbo.NashvilleHousing
 

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted  = CONVERT(Date,SaleDate)


--Populate Property Address Data

Select *  
From PorfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
Order by ParcelID

Select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PorfolioProject.dbo.NashvilleHousing  as a
Join PorfolioProject.dbo.NashvilleHousing as b
 on a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null


 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 From PorfolioProject.dbo.NashvilleHousing  as a
Join PorfolioProject.dbo.NashvilleHousing as b
 on a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null

 --Breaking Out Addres into Individual Columns(Address,  City State)

Select PropertyAddress
From PorfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID


SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) as Address
From PorfolioProject.dbo.NashvilleHousing 


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar (255);

Update NashvilleHousing
SET PropertySplitAddress  = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar (255);

Update NashvilleHousing
SET PropertySplitCity  =SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1 , LEN(PropertyAddress))

Select *
From PorfolioProject.dbo.NashvilleHousing



Select OwnerAddress
From PorfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PorfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar (255);

Update NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar (255);

Update NashvilleHousing
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar (255);

Update NashvilleHousing
SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
From PorfolioProject.dbo.NashvilleHousing


--Change Y And N To Yes and No in "Sold As Vacant"

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PorfolioProject.dbo.NashvilleHousing  
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From PorfolioProject.dbo.NashvilleHousing  

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER  (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 LegalReference
			 ORDER BY UniqueID
			 ) row_num

From PorfolioProject.dbo.NashvilleHousing
--order by ParcelID
 )

Select * 
From RowNumCTE
Where row_num > 1
--order by PropertyAddress

--Delete Unused Columns

Select *
From PorfolioProject.dbo.NashvilleHousing

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress 

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertySlpitCity 

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate



