Select * From ProjectOne..NashvilleHousing

-- Standartize date sale 

update NashvilleHousing -- not working for some reason
Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing -- using with pair with ALTER (ddl command) and it worked
Add  SaleDateConverted Date;

update NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

Select * From ProjectOne..NashvilleHousing Where PropertyAddress is NULL

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress From ProjectOne..NashvilleHousing a
JOIN ProjectOne..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

update a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) From ProjectOne..NashvilleHousing a
JOIN ProjectOne..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

Select PropertyAddress From ProjectOne..NashvilleHousing


-- breaking address into individual column
Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address  -- '-1' is to get rid of comma
From ProjectOne..NashvilleHousing

ALTER TABLE NashvilleHousing 
Add  PropertySplitCity nvarchar(255);

update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

ALTER TABLE NashvilleHousing  
Add PropertySplitAdress nvarchar(255); 

update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

Select * From ProjectOne..NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '. '), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '. '), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '. '), 1)
From ProjectOne..NashvilleHousing

ALTER TABLE NashvilleHousing 
Add  OwnerSplitAddress nvarchar(255);

update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '. '), 3)

ALTER TABLE NashvilleHousing  
Add OwnerSplitState nvarchar(255); 

update NashvilleHousing
Set OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '. '), 2)

ALTER TABLE NashvilleHousing  
Add OwnerSplitCity nvarchar(255); 

update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '. '), 1)

Select * From ProjectOne..NashvilleHousing

Select distinct(SoldAsVacant), count(SoldAsVacant) 
From ProjectOne..NashvilleHousing Group By SoldAsVacant
Order By 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
else SoldAsVacant
END
From ProjectOne..NashvilleHousing Group By SoldAsVacant
Order By 2

Update NashvilleHousing
SET  SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y'  THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
else SoldAsVacant
END

--Remove Duplicates

WITH  RowNumCTE as (
Select *, ROW_NUMBER() OVER(
Partition BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID) row_num

From ProjectOne..NashvilleHousing 
)Select * From RowNumCTE
Where row_num > 1 --order by PropertyAddress

--remove unused columns

Select * 
From ProjectOne..NashvilleHousing

Alter Table NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

