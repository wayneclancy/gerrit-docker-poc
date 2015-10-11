#Gerrit - Postgres Docker example


This is a docker wrapper for docker-library/postgres and openfrontier/docker-gerrit. Both of which are availible as open souce.
Gerrit has its own docker storage volume. 
Postgres and Gerrit run on seperate containers with dedicated TCP postgres access on port 5432
There is a control shell script with various functions to manage day to day admin of the Gerrit service. This includes snapshotting.

##Deployment

All you need to do to get everything working once the code and been cloned on a local machine with docker installed is run the follow:

./gerrit-pg-ctl.sh rebuild

This will build docker-gerrit and docker/libary/postgres locally. Once this is complete you can start the service with

./gerrit-pg-ctl.sh start

After around 10 seconds you should be able to access the gerrit server via http://127.0.0.1:8080
 
##Backup / Snapshotting

You can use gerrit-pg-ctl.sh to create snapshots of both Postgres and Gerris

./gerrit-pg-ctl.sh snapshot

This will create a snapshot on the local instance with a timestamp. Both PG and Gerret snapshots will have the same timestamp. You can see current snapshots by running

./gerrit-pg-ctl.sh listsnapshots
waynec/pg-gerrit-snapshot-2015-10-11214308   latest              84ab6530248f        20 minutes ago      265.4 MB
waynec/gerrit-snapshot-2015-10-11214308      latest              b2bc991843cb        20 minutes ago      413.6 MB

## Misc

This is a fairly basic script without any error checking etc. Its just used as a control script to make easy use of the dockerfiles.

The wrapper script has the following option

start: 		Start the Gerrit container service
stop:  		Stop the Gerrit container servers
restart: 	Stop/start Gerris container server
reload: 	See restart 
rebuild: 	Builds all docker images from source in wclancy/
destroy:        Removed the docker images from the service (use with caution) 
logs:		Show docker logs from each instance
snapshot: 	Creates a timestamp based snapshot
listsnapshot:	List all snapshotss

##Todo

Add error checking and service health checks

