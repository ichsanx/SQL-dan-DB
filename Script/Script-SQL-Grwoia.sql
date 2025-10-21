SELECT name AS track_name, composer
FROM track
WHERE name IS NOT NULL 
    AND composer IS NOT NULL
    AND (name LIKE 'G%' 
    OR composer LIKE '%A')
ORDER BY composer


SELECT CustomerId, BillingCountry, 
       SUM(Total) AS jumlah_pembelian,
       AVG(Total) AS rata_pembelian
FROM Invoice i
WHERE InvoiceDate BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY 1, 2
HAVING AVG(Total) > 5;

--CASE WHEN
SELECT CustomerId , Country ,
CASE 
	WHEN Country in ('USA','Canada') THEN 'America Tengah'
	WHEN Country in ('Brazil') THEN 'America Selatan'
	ELSE 'Rest Of The World'
	END as Group_Negara	
FROM Customer c 

/*SubQuery*/
WITH top_spender AS (
    SELECT i.CustomerId, SUM(Total) AS spending
    FROM Invoice i
    GROUP BY CustomerId
    ORDER BY spending DESC
    LIMIT 5
)
SELECT c.FirstName, c.LastName, ts.spending
FROM Customer c
JOIN top_spender ts
ON c.CustomerId = ts.CustomerId;

--CTE
WITH total_average AS (
    SELECT 
        CustomerId, 
        InvoiceDate, 
        BillingCountry, 
        Total
    FROM invoice
    WHERE Total > (SELECT AVG(Total) FROM invoice)
)
SELECT 
    ta.InvoiceDate, 
    ta.BillingCountry, 
    ta.Total, 
    c.FirstName
FROM total_average ta
JOIN customer c
ON c.CustomerId = ta.CustomerId;




























































