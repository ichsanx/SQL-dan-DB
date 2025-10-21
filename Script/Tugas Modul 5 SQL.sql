--Answer no.2
SELECT product_name ,product_line ,MAX(msrp) AS MSRP_Tertinggi
FROM products
GROUP BY product_line 
ORDER BY MSRP_Tertinggi DESC 

--Answer no.3
SELECT e.office_code ,LOWER(e.first_name || ' ' || e.last_name ) AS Nama_Agent ,e.job_Title ,
COUNT(c.sales_rep_employee_number) AS Layanan  
FROM customers c JOIN employees e ON c.sales_rep_employee_number = e.employee_number 
GROUP BY e.office_code , e.first_name ,e.last_name ,e.job_Title 
HAVING COUNT(c.sales_rep_employee_number) > 3
ORDER BY Layanan DESC 

--Answer no.4
SELECT c.city ,COUNT(DISTINCT od.quantity_ordered) AS Quantity 
FROM customers c JOIN orders o ON c.customer_number = o.customer_number 
					JOIN orderdetails od ON o.order_number = od.order_number 
					GROUP BY c.city 
					ORDER BY Quantity DESC 
					
--Answer no.5
SELECT c.city ,AVG(od.quantity_ordered) AS Average_Qty_Order 
FROM customers c JOIN orders o ON c.customer_number = o.customer_number 
					JOIN orderdetails od ON o.order_number = od.order_number 
					GROUP BY c.city 
					ORDER BY Average_Qty_Order DESC 

					
WITH OrderBasket AS (-- Menghitung basket size per transaksi
    SELECT 
        o.customer_number,
        o.order_number, 
        SUM(od.quantity_ordered) AS basket_size
    FROM orders o
    JOIN orderdetails od ON o.order_number = od.order_number
    GROUP BY o.customer_number, o.order_number)
SELECT 
    c.city, 
    AVG(ob.basket_size) AS avg_basket_size
FROM OrderBasket ob
JOIN customers c ON ob.customer_number = c.customer_number
GROUP BY c.city
ORDER BY avg_basket_size DESC;