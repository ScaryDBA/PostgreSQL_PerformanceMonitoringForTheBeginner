--just a sample query
SELECT * FROM bluebox.film
WHERE release_date > '2023-10-01'::date;


--remember to get the correct file name
SELECT pg_current_logfile();

SELECT pg_read_file('log/postgresql-2025-09-10_193302.log');




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



--additional log settings
ALTER SYSTEM SET auto_explain.log_min_duration = '1s';  -- Log queries that take longer than 1 second
ALTER SYSTEM SET auto_explain.log_analyze = TRUE;       -- Include actual execution time
ALTER SYSTEM SET auto_explain.log_buffers = TRUE;       -- Include buffer usage
ALTER SYSTEM SET auto_explain.log_timing = TRUE;        -- Include detailed timing information
ALTER SYSTEM SET auto_explain.log_verbose = TRUE;       -- Include detailed information





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
-- add the following to the postgresql.conf file
ALTER SYSTEM SET pg_stat_statements.track = 'top'; --can be none, top, all, top is default means user statements
ALTER SYSTEM SET pg_stat_statements.track_planning = 'on'; --comes with performance hit
--also track_utility, defaults to on, for tracking SELECT INSERT UPDATE
--also save to have query statistics survive a reboot, on by default




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
SELECT pg_stat_statements_reset(0, 0, -3937625263988876720);





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