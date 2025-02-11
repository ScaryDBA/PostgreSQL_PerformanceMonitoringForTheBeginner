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

##load up bluebox
pg_restore -C -d postgres -U postgres /bu/bluebox_v0.3.dump 

