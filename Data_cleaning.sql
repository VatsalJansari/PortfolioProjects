--Selecting Data 

select *
from housingData 

--Updating Columns 

select saledate,CONVERT(date,saledate)
from HousingData

alter table housingdata
add salesdate date

update HousingData
set salesdate = CONVERT(date,saledate)

select salesdate
from HousingData

--Updating address

select PropertyAddress
from HousingData
where PropertyAddress is null


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from HousingData a
join HousingData b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from HousingData a
join HousingData b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--split the address

select propertyaddress
from HousingData

select 
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as StreetName,
SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as CityName
from HousingData

alter table housingdata
add StreetName varchar(255)

update HousingData
set StreetName = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)

alter table housingdata
add Cityname nvarchar(255)

update HousingData
set Cityname = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

select *
from HousingData

--Other way to split column

select owneraddress
from HousingData

select
PARSENAME(replace(owneraddress,',','.'),3) as ownerstreetname,
PARSENAME(replace(owneraddress,',','.'),2) as ownercityname,
PARSENAME(replace(owneraddress,',','.'),1)as ownerstate
from HousingData

alter table housingdata
add ownerStreetName varchar(255)

update HousingData
set ownerStreetName =PARSENAME(replace(owneraddress,',','.'),3)

alter table housingdata
add ownercityname varchar(255)

update HousingData
set ownercityname = PARSENAME(replace(owneraddress,',','.'),2)

alter table housingdata
add ownerstate varchar(255)

update HousingData
set ownerstate = PARSENAME(replace(owneraddress,',','.'),1)

select *
from HousingData

--convert Data 

select soldasvacant, count(soldasvacant)
from HousingData
group by SoldAsVacant

select soldasvacant,
case
when soldasvacant='y' then 'yes'
when soldasvacant='n' then 'no'
else SoldAsVacant
end
from housingdata

update HousingData
set SoldAsVacant=
case
when soldasvacant='y' then 'yes'
when soldasvacant='n' then 'no'
else SoldAsVacant
end

select *
from HousingData

--Remove duplicate 

with rownumm as (
select *,
row_number() over (
partition by parcelId,propertyaddress,saledate,saleprice,Legalreference
order by uniqueid) rownum
from housingdata
)
delete 
from rownumm
where rownum >1

--Deleting Column

select *
from HousingData

alter table housingdata
drop column propertyaddress,owneraddress,saledate,taxdistrict