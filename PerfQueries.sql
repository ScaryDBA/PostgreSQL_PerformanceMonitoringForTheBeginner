--just a sample query
SELECT * FROM bluebox.film
WHERE release_date > '2023-10-01'::date;


--remember to get the correct file name
SELECT pg_read_file('log/postgresql-2025-02-11_161343.log');
