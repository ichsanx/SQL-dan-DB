--1. Basic Selection
SELECT email, phone from Customer

--2. Menggunakan Filter
SELECT FirstName, LastName , Email 
from Customer
where country = 'Brazil'

--2. Menggunakan Filter Kecuali Brazil yaitu !=
SELECT FirstName, LastName , Email 
from Customer
where country != 'Brazil'

--3. Mengurutkan Data
SELECT FirstName, BirthDate
from Employee
order by BirthDate DESC  

--4. Menggunakan Limit
SELECT * from Employee
limit 2

--5. Menggunakan Alias
SELECT FirstName as Nama_Depan from Employee



--Challenge
--Buat Query untuk mengambil nama depan, nama belakang customer
select FirstName , lastname from Customer

--Buat Query mengambil seluruh informasi karyawan yang title nya IT Staff
select * 
from Employee
where Title = 'IT Staff'



--FUNCTION 
SELECT MAX(UnitPrice) 
from Track

--Aggregation
--Berapa rata2 harga track yang di jual per komposer
select Composer, AVG(UnitPrice) as Harga_Rata2
from Track 
group by Composer 
ORDER BY Harga_Rata2

--Aggregation
--Berapa rata2 harga track yang di jual per komposer
select Composer, AVG(UnitPrice) as Harga_Rata2
from Track 
group by Composer 
ORDER BY 2

--Case WHEN 
SELECT 
	CustomerId ,
	Country ,
	CASE Country 
	When 'USA' Then 'Domestic'
	Else 'Foreign'
	END as CustomerGroup
FROM Customer


--CHALLENGE
--Buat Query yang menunjukan banyaknya invoice berdasarkan Billing Country (count)
Select BillingCountry , COUNT(BillingCountry) as Invoice
from Invoice
group by BillingCountry
ORDER by 2 DESC 



--HAVING 
SELECT InvoiceId, SUM(Quantity) as SUM_QTY
FROM InvoiceLine il 
group by InvoiceId 
HAVING SUM_QTY > 10




-- Contoh Penggabungan 2 tabel
SELECT *
from Album alb inner join Artist art
	on alb.ArtistId = art.ArtistId 
where art.name = 'Aerosmith'


-- Gabungin 3 TABLE 
select * 
from Track as tr
left join Album as al ON tr.AlbumId = al.AlbumId 
left JOIN Artist as ar On ar.ArtistId = al.ArtistId 


--Practice Question
--Buatlah QUERY yang menunjukan InvoiceID + Sales agent(employe)
--terurut berdasarkan nama agent(employe)
SELECT i.InvoiceId , e.FirstName
FROM Invoice i
left join Customer c ON i.CustomerId = c.CustomerId  
left join Employee e ON c.SupportRepId = e.EmployeeId
ORDER BY e.FirstName 



--Cari Artist mengandung nama john
--Cari track nya mengandung nama hop
SELECT a.Name, "Artist" as entity 
from Artist a
WHERE Name LIKE "%john%"
UNION
SELECT t.Name, "Track" as entity 
from Track t 
WHERE Name LIKE "%hop%"

--Menggunakan Union / INTERSECT / EXCEPT -> nama kolom harus sama

--Soal:
--Tampilkan nama depan customer yang bukan nama depan employee
--hint : gunakan EXCEPT
SELECT DISTINCT c.FirstName
FROM Customer c 
except
SELECT DISTINCT e.FirstName
FROM Employee e 





--Belajar Sub Query
--Ambil semua track dengan genre Rock
select * from Track
WHERE GenreId in
(select genreid from Genre
where Name = 'Rock'
)

--Carilah agent yang pernah melayani top 5 customer dengan total spending paling banyak
--Pendekatan 1 Sub Query
SELECT c.SupportRepId, Top_Spender.customerId
from Customer c right join
	(SELECT i.customerId, SUM(Total) as Total_Spending
	from Invoice i 
	group by CustomerId 
	ORDER by Total_Spending desc
	LIMIT 5) as Top_Spender
on c.customerId = Top_Spender.customerId 

--Pendekatan 2 (CTE) Sub Query
WITH Top_Spender as 
	(SELECT i.customerId, SUM(Total) as Total_Spending
	from Invoice i 
	group by CustomerId 
	ORDER by Total_Spending desc
	LIMIT 5)
SELECT c.SupportRepId, Top_Spender.customerId
from Customer c right join Top_Spender
on c.customerId = Top_Spender.customerId 

--Pendekatan 3 (CTE) Sub Query
WITH Top_Spender as 
	(SELECT i.customerId, SUM(Total) as Total_Spending
	from Invoice i 
	group by CustomerId 
	ORDER by Total_Spending desc
	LIMIT 5), --Gunakan Koma pemisah CTE
Lowest_spemder as -- CTE setelah pertama tidak menggunakan with
	(SELECT i.customerId, SUM(Total) as Total_Spending
	from Invoice i 
	group by CustomerId 
	ORDER by Total_Spending desc
	LIMIT 5)
SELECT c.SupportRepId, Top_Spender.customerId
from Customer c right join Top_Spender
on c.customerId = Top_Spender.customerId 





 