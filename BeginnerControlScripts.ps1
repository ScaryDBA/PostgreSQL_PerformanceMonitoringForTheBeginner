##set up a new PostgreSQL cluster
docker run `
    --name PerfTuning `
    -p 5432:5432 `
    -e POSTGRES_PASSWORD=*cthulhu1988 `
    -v C:\bu:/bu `
    -d timescale/timescaledb-ha:pg17

#for cleanups & testing
#docker stop PerfTuning
#docker rm PerfTuning

##load up bluebox_dev database
pg_restore -C -d postgres -U postgres /bu/bluebox_v0.3.dump 


## set up above, below are demos

## open bash within the container
docker exec -it PerfTuning "bash";
## edit the config file
vi ~/pgdata/data/postgresql.conf

## i to insert, esc to quit inserting
## :wq to save & quit
## yes, I use nano more than vi, but I'm not installing it

## search for /logging_collector
## remove comment and change value from 'off' to 'on'
## search for /log_duration
## remove comment and change value from 'off' to 'on'

## restarting the cluster is required
pg_ctl stop
docker start PerfTuning

## get back into the container and get the file name
docker exec -it PerfTuning "bash";
## directory
cd ~/pgdata/data/log
ls

## run a query over in DBeaver & show the log

## expand the log information captured
vi ~/pgdata/data/postgresql.conf

## find /log_statement

## search for /min_duration_statement
## remove comment and change value from -1 to 5ms (NOTE: only for demo/testing purposes)
## search for /shared_preload_libraries
## add auto_explain
pg_ctl stop
docker start PerfTuning

## add the following to the postgresql.conf file
auto_explain.log_min_duration = '1s'  -- Log queries that take longer than 1 second
auto_explain.log_analyze = true       -- Include actual execution time
auto_explain.log_buffers = true       -- Include buffer usage
auto_explain.log_timing = true        -- Include detailed timing information
auto_explain.log_verbose = true       -- Include detailed information

pg_ctl reload

## one more time into the postgresql.conf file
## find /log_line_prefix

## back to the slides

## edit shared_preload_libraries to include pg_stat_statements

## restarting the cluster is required
pg_ctl stop
docker start PerfTuning

