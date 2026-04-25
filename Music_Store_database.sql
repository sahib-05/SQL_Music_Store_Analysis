SELECT * FROM album;

-- set 1
-- Q1. Who is the senior most employee based on job title?

SELECT first_name,
       last_name,
       title,
       levels
FROM employee
ORDER BY levels DESC
LIMIT 1;


-- Q2. Which countries have the most invoices?

SELECT billing_country,
       COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;


-- Q3. What are top 3 values of total invoice?

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;


-- Q4. Which city has the best customers?
-- City with the highest sum of invoice totals

SELECT billing_city,
       SUM(total) AS total_invoice_amount
FROM invoice
GROUP BY billing_city
ORDER BY total_invoice_amount DESC
LIMIT 1;


-- Q5. Who is the best customer?
-- Customer who has spent the most money

SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

-- set 2:-
-- Q1. Return email, first name, last name & Genre of all Rock Music listeners
-- Ordered alphabetically by email

SELECT DISTINCT c.email,
       c.first_name,
       c.last_name,
       g.name AS genre
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;


-- Q2. Top 10 rock bands (artist name + total track count)

SELECT ar.name AS artist_name,
       COUNT(t.track_id) AS total_track_count
FROM artist ar
JOIN album al
    ON ar.artist_id = al.artist_id
JOIN track t
    ON al.album_id = t.album_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.name
ORDER BY total_track_count DESC
LIMIT 10;


-- Q3. Tracks longer than average song length
-- Ordered by song length (longest first)

SELECT name,
       milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;

-- set 3:-
-- Q1. Find how much amount spent by each customer on artists?
-- Return customer name, artist name and total spent

SELECT 
    c.first_name,
    c.last_name,
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id

JOIN invoice_line il
ON i.invoice_id = il.invoice_id

JOIN track t
ON il.track_id = t.track_id

JOIN album al
ON t.album_id = al.album_id

JOIN artist ar
ON al.artist_id = ar.artist_id

GROUP BY 
    c.first_name,
    c.last_name,
    ar.name

ORDER BY total_spent DESC;



-- Q2. Find out the most popular music Genre for each country.
-- Return each country along with the top Genre

SELECT 
    c.country,
    g.name AS genre_name,
    COUNT(*) AS total_purchases
FROM customer c

JOIN invoice i
ON c.customer_id = i.customer_id

JOIN invoice_line il
ON i.invoice_id = il.invoice_id

JOIN track t
ON il.track_id = t.track_id

JOIN genre g
ON t.genre_id = g.genre_id

GROUP BY 
    c.country,
    g.name

ORDER BY 
    c.country,
    total_purchases DESC;



-- Q3. Determine the customer that has spent the most on music for each country.
-- Return country, customer name and total spent

SELECT 
    c.first_name,
    c.last_name,
    i.billing_country,
    SUM(i.total) AS total_spent
FROM customer c

JOIN invoice i
ON c.customer_id = i.customer_id

GROUP BY 
    c.first_name,
    c.last_name,
    i.billing_country

ORDER BY total_spent DESC;