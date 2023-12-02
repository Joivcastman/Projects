select * 
from PortfolioProject.dbo.NashvilleHousing


select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted 
from PortfolioProject.dbo.NashvilleHousing



select * 
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


update a
set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]



SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as city

from PortfolioProject.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))


select *
from PortfolioProject.dbo.NashvilleHousing







select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing




select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select DISTINCT(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
,	CASE when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant ='N' THEN 'No'
	ELSE SoldAsVacant
	END
from PortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant =	CASE when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant ='N' THEN 'No'
	ELSE SoldAsVacant
	END

	SELECT *
	from PortfolioProject.dbo.NashvilleHousing





WITH ROWNUMCTE AS(
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
				UniqueID
				) ROW_NUM

from PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
/**seLECT *
FROM ROWNUMCTE
WHERE ROW_NUM >1
ORDER BY PropertyAddress
*/

DELETE
FROM ROWNUMCTE
WHERE ROW_NUM >1






ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate