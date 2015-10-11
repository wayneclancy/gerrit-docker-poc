#Gerrit - Postgres Docker example


This is a docker wrapper for docker-library/postgres and openfrontier/docker-gerrit. Both of which are availible as open souce.
Gerrit has its own docker storage volume. 
Postgres and Gerrit run on seperate containers with dedicated TCP postgres access on port 5432
There is a control shell script with various functions to manage day to day admin of the Gerrit service. This includes snapshotting.

##Deployment

All you need to do to get everything working once the code and been cloned on a local machine with docker installed is run the follow:</br>

./gerrit-pg-ctl.sh rebuild</br>

This will build docker-gerrit and docker/libary/postgres locally. Once this is complete you can start the service with</br>

./gerrit-pg-ctl.sh start</br>

After around 10 seconds you should be able to access the gerrit server via http://127.0.0.1:8080</br>
 
##Backup / Snapshotting

You can use gerrit-pg-ctl.sh to create snapshots of both Postgres and Gerris</br>

./gerrit-pg-ctl.sh snapshot</br>

This will create a snapshot on the local instance with a timestamp. Both PG and Gerret snapshots will have the same timestamp. You can see current snapshots by running</br>

./gerrit-pg-ctl.sh listsnapshots</br>
waynec/pg-gerrit-snapshot-2015-10-11214308   latest              84ab6530248f        20 minutes ago      265.4 MB</br>
waynec/gerrit-snapshot-2015-10-11214308      latest              b2bc991843cb        20 minutes ago      413.6 MB</br>

## Misc

This is a fairly basic script without any error checking etc. Its just used as a control script to make easy use of the dockerfiles.

The wrapper script has the following option</br>

start: 		Start the Gerrit container service</br>
stop:  		Stop the Gerrit container servers</br>
restart: 	Stop/start Gerris container server</br>
reload: 	See restart </br>
rebuild: 	Builds all docker images from source in wclancy/</br>
destroy:        Removed the docker images from the service (use with caution) </br>
logs:		Show docker logs from each instance</br>
snapshot: 	Creates a timestamp based snapshot</br>
listsnapshot:	List all snapshotss</br>
status:		Checks if local Gerrit service is running on 8080</br>

##Todo

Add error checking and snapshot restore/tar export 

