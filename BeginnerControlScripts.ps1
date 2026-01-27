## Just a note, originally, this code assumed logs first, then pg_stat_statements
## However, I now teach pg_stat_statements first, then logging
## So, this code is a bit out of order compared to the slides

## set up a new PostgreSQL cluster
## not intended as demo code, search for '## demo'
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

## open up bash
docker exec -it HamShackRadio "bash";

## just in case, in bash
cp ~/pgdata/data/postgresql.conf ~/pgdata/data/postgresql.conf.bak

## quick switches, bash
## to just run simple logs
mv ~/pgdata/data/postgresql.conf.start ~/pgdata/data/postgresql.conf
## to run full log info
mv ~/pgdata/data/postgresql.conf.full ~/pgdata/data/postgresql.conf


## set up above, below are demos
## demo

## open bash within the container
docker exec -it PerfTuning "bash";
## in bash, edit the config file
vi ~/pgdata/data/postgresql.conf

## i to insert, esc to quit inserting
## :wq to save & quit
## yes, I use nano more than vi, but I'm not installing it

## search using the slash, /, for /logging_collector
## remove comment, del, and change value from 'off' to 'on' using insert
## search for /log_duration
## remove comment and change value from 'off' to 'on'

## restarting the cluster is required, sometimes
pg_ctl stop
## start the container
docker start PerfTuning

## get back into the container and get the file name
docker exec -it PerfTuning "bash";
## directory
cd ~/pgdata/data/log
ls

## run a query over in DBeaver & show the log

## expand the log information captured, in bash
vi ~/pgdata/data/postgresql.conf


## find /log_statement

## search for /min_duration_statement
## remove comment and change value from -1 to 5ms (NOTE: only for demo/testing purposes)
## search for /shared_preload_libraries
## add auto_explain
pg_ctl stop
docker start PerfTuning


## back in bash
pg_ctl reload



## and now for pg_stat_statements
docker exec -it PerfTuning "bash";
vi ~/pgdata/data/postgresql.conf

## one more time into the postgresql.conf file
## find /log_line_prefix

## back to the slides

## edit shared_preload_libraries to include pg_stat_statements

## restarting the cluster is required
pg_ctl stop
docker start PerfTuning



