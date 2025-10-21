--Challenge:
--1.Tampilkan first_name dan last_name dari tabel actor.
--
--2.Tampilkan gabungan first_name dan last_name dengan huruf kecil dan nama kolom actor_name.
--(Hint: gunakan || untuk menggabungkan 2 kolom. Contoh: SELECT a || b)
--
--3.Kamu mengingat aktor dengan nama depan “JOE”.
--Tampilkan actor_id, first_name, dan last_name orang tersebut.
--
--4.Masih seperti soal sebelumnya, sekarang cari orang yang nama belakangnya mengandung kata “LI”, tetapi coba urutkan berdasarkan nama belakang.
--Jika ada orang dengan nama belakang yang sama, prioritaskan pengurutan dengan nama depan.
--
--5.Dengan fungsi IN di SQL, tampilkan ID negara Afghanistan, Bangladesh, dan China.
--
--6.Tampilkan semua nama belakang aktor dan juga hitung ada berapa banyak aktor dengan nama belakang tersebut.
--
--7.Sama seperti nomor 7, tetapi sekarang buang nama belakang aktor yang hanya dimiliki 1 orang.
--
--8.Cara nama depan, nama belakang dan alamat dari setiap staff member.
--Gunakan tabel staff dan address.
--
--9.Cari berapa banyak penjualan (amount) yang berhasil dibuat setiap staff_member pada bulan Agustus 2005.
--Gunakan tabel staff dan payment.
--
--10.Tampilkan judul film dan berapa banyak aktor yang ada di setiap film.
--
--11.Cari informasi customer dan berapa banyak biaya yang dikeluarkan oleh setiap customer.
--Urutkan hasil pencarian berdasarkan nama belakang customer secara abjad.
--
--12.Perusahaan ingin membuat marketing campaign melalui email di Kanada.
--Cari semua email customer yang berasal dari Kanada. Gunakan CTE jika bisa.
--
--13.Tampilkan nama film yang paling sering disewa (rental) dan urutkan dari yang paling populer.
--
--14.Buat query yang menunjukkan berapa banyak revenue (amount) yang diperoleh masing-masing toko.
--
--15.Cari 5 genre film dengan gross revenue tertinggi, diurutkan dari yang paling laku terlebih dahulu.
--(Hint: genre terdapat di tabel film_category.))



--JAWABAN
--Soal no.1
SELECT first_name, last_name 
FROM actor

--Soal no.2
SELECT LOWER(first_name || ' ' || last_name) AS actor_name
from actor;

--Soal no.3
SELECT actor_id , first_name , last_name 
FROM actor
WHERE first_name  like '%JOE%'

--Soal no.4
SELECT actor_id , first_name , last_name 
FROM actor
WHERE last_name like '%LI%'
GROUP BY first_name 
ORDER BY last_name ASC 

--Soal no.5
SELECT country_id, country as Negara
FROM country c
WHERE country in ('Afganistan', 'Bangladesh', 'China')

--Soal no.6
SELECT last_name , COUNT(last_name) as JML_Last_Name 
FROM actor 
GROUP BY last_name

--Soal no.7
SELECT last_name , COUNT(last_name) as JML_Last_Name 
FROM actor 
GROUP BY last_name 
HAVING JML_Last_Name > 1


--Soal no.8
SELECT s.first_name as NamaDepan, s.last_name as NamaBelakang, a.address as Alamat
FROM staff s left join address a 
on s.address_id = a.address_id 

--Soal no.9
SELECT s.staff_id , LOWER(s.first_name || ' ' || s.last_name) as Nama_Staff, SUM(p.amount) as Total_Sales 
FROM staff s join payment p 
on s.staff_id = p.staff_id 
WHERE (p.payment_date) BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY s.staff_id ,Nama_Staff
ORDER BY Total_Sales

--Soal no.10
SELECT f.title ,COUNT(fa.actor_id) as Jumlah_Aktor
FROM film f 
INNER JOIN film_actor fa ON f.film_id =  fa.film_id 
GROUP BY f.title 

--Soal no.11
SELECT c.customer_id ,c.last_name ,SUM(p.amount) 
FROM customer c 
JOIN payment p ON c.customer_id = p.customer_id 
GROUP BY c.last_name

--Soal no.12
WITH Location_CTE AS (
SELECT 
	a.address_id ,
	c.city_id ,
	c2.country_id ,
	c2.country 
FROM address a JOIN city c ON a.city_id = c.city_id 
JOIN country c2 ON c.country_id = c2.country_id )
SELECT 
	c3.email ,
	c3.first_name ,
	c3.last_name , 
	(SELECT country FROM Location_CTE WHERE address_id = Location_CTE.address_id) AS Country
FROM customer c3 
WHERE c3.address_id IN (
SELECT address_id FROM Location_CTE
WHERE country = 'Canada');

--Soal no.13
SELECT 
	f.title AS Film_Title,
	COUNT(r.rental_id) AS Top_Rental 
FROM film f JOIN inventory i ON f.film_id = i.film_id 
			JOIN rental r ON i.inventory_id  = r.inventory_id 
GROUP BY f.film_id 
ORDER BY Top_Rental DESC

--Soal no.14
SELECT 
	s.store_id ,
	SUM(p.amount) AS Revenue
FROM store s JOIN inventory i ON s.store_id = i.store_id 
				JOIN rental r ON i.inventory_id = r.inventory_id 
				JOIN payment p ON r.rental_id = p.rental_id 
GROUP BY s.store_id 
ORDER BY Revenue DESC 

--Soalno.15
SELECT c.name AS Genre,
SUM(p.amount) AS TOP_Rev
FROM film_category fc JOIN category c ON fc.category_id = c.category_id 
						JOIN film f ON fc.film_id = f.film_id 
						JOIN inventory i ON f.film_id = i.film_id 
						JOIN rental r ON i.inventory_id = r.inventory_id 
						JOIN payment p ON r.rental_id = p.rental_id 
GROUP BY c.name
ORDER BY TOP_Rev DESC  
LIMIT 5;