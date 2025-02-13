--just a sample query
SELECT * FROM bluebox.film
WHERE release_date > '2023-10-01'::date;


--remember to get the correct file name
SELECT pg_read_file('log/postgresql-2025-02-11_161343.log');




--Longer running query
SELECT
	f.title,
	s.phone,
	c.full_name,
	r.rental_period
FROM
	rental AS r
JOIN inventory AS i
ON
	r.inventory_id = i.inventory_id
JOIN customer AS c
ON
	r.customer_id = c.customer_id
JOIN film AS f
ON
	i.film_id = f.film_id
JOIN store AS s
ON
	i.store_id = s.store_id
ORDER BY
	r.rental_period ASC;



--CSS
--starting with pg_stat_activity
SELECT
	psa.datname,
	psa.usename,
	psa.query,
	psa.xact_start,
	psa.query_start
FROM
	pg_stat_activity AS psa;




--pg_stat_statements
SELECT * from pg_stat_statements AS pss;



--in order to know when the statistics are valid for
SELECT * FROM pg_stat_statements_info;


--you can reset the statistics yourself
SELECT pg_stat_statements_reset(); --parameters include database id, user id, and query id
SELECT pg_stat_statements_reset(userid Oid, dbid Oid, queryid bigint); --use zero to skip a value

--let's reset a query
--let's reset a query
SELECT * FROM inventory;

SELECT
	pss.queryid,
	pss.query,
	pss.total_exec_time,
	pss.min_exec_time,
	pss.stddev_exec_time
FROM
	pg_stat_statements AS pss
WHERE
	query = 'SELECT * FROM inventory';

--get the id for the query
SELECT pg_stat_statements_reset(0, 0, 5356259745220120273);





--explain plans
EXPLAIN
SELECT * FROM film
WHERE release_date > '2023-10-01'::date;

EXPLAIN ANALYZE
SELECT * FROM film
WHERE release_date > '2023-10-01'::date;


EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM film
WHERE release_date > '2023-10-01'::date;


EXPLAIN (ANALYZE,BUFFERS)
SELECT * FROM film f
	JOIN film_cast fc USING (film_id)
	JOIN person p USING (person_id)
WHERE release_date > '2023-10-01'::date;