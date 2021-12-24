
select *
From PortfolioProject.dbo.NashvilleHousing



-- Standardize Date Format

select SaleDate, convert(date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
add SaleDateConverted date

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)






-- Populating Missing Property Address Data

select *
From PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null


select *
From PortfolioProject.dbo.NashvilleHousing
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]







--	Address into individual columns

select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing


select 
SUBSTRING (Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as Property_Street_Address
, SUBSTRING (Propertyaddress, CHARINDEX(',', PropertyAddress) +1, len(Propertyaddress)) as Property_City
From PortfolioProject.dbo.NashvilleHousing


Alter table NashvilleHousing
add Property_Street_Address nvarchar(255),
	Property_City nvarchar(255)


update NashvilleHousing
set Property_Street_Address = SUBSTRING (Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1),
	Property_City = SUBSTRING (Propertyaddress, CHARINDEX(',', PropertyAddress) +1, len(Propertyaddress))


select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(replace(OwnerAddress, ',', '.'), 1) as Owner_State
, PARSENAME(replace(OwnerAddress, ',', '.'), 2) as Owner_City
, PARSENAME(replace(OwnerAddress, ',', '.'), 3) as Owner_St_Address
From PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add Owner_St_Address nvarchar(255),
	Owner_City nvarchar(255),
	Owner_State nvarchar(255)


update NashvilleHousing
set Owner_St_Address = PARSENAME(replace(OwnerAddress, ',', '.'), 3),
	Owner_City = PARSENAME(replace(OwnerAddress, ',', '.'), 2),
	Owner_State = PARSENAME(replace(OwnerAddress, ',', '.'), 1)









-- Change Y and N as Yes and No in Sold As Vacant field


select SoldAsVacant
From PortfolioProject.dbo.NashvilleHousing

select distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end
From PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end


