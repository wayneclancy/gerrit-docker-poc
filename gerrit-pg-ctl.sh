#!/bin/bash

# Docker Control script for managing gerrit / pgSQL including snapshots
# Wayne Clancy (wayneclancy80@googlemail.com)


check_docker_images() { 
 	if [[ "$(docker images -q waynec/postgres 2> /dev/null)" == "" ]]; then
  	  echo "Missing waynec/postgres image please run $0 rebuild" 
	  exit 1
	fi 
	if [[ "$(docker images -q waynec/gerrit 2> /dev/null)" == "" ]]; then
	  echo "Missing waynec/gerrit image please run $0 rebuild"
	  exit 1
	fi
}

rebuild() {
       docker build --no-cache -t waynec/postgres waynec/postgres
       docker build --no-cache -t waynec/gerrit waynec/gerrit 
       docker run --name gerrit_volume waynec/gerrit 
       echo "Built all images and gerrit volume"
}

getlogs() {
       docker logs pg-gerrit
       docker logs gerrit
} 
snapshot() {
       DATE=`date +%Y-%m-%d%H%M%S`
       docker commit -p gerrit waynec/gerrit-snapshot-$DATE
       docker commit -p pg-gerrit waynec/pg-gerrit-snapshot-$DATE
} 
listsnapshot() {
       docker images | grep snapshot
}
status() {
	status=`curl -s --head http://127.0.0.1:8080 | head -n 1 | grep -c OK`
	if [ $status -eq 1 ]
		then
			echo "Gerrit service is up and running on http://127.0.0.1:8080"
			exit 0
		else
			echo "Gerrit service appears to be down on http://127.0.0.1:8080.. consider a $0 restart"
			exit 2
		fi
}      
start() {
        #Start postgres docker
         docker run \
        --volumes-from gerrit_volume \
         --name pg-gerrit \
	-p 5432:5432 \
	-e POSTGRES_USER=gerrit \
	-e POSTGRES_PASSWORD=gerrit \
	-e POSTGRES_DB=gerrit \
	-d waynec/postgres
        echo "Started Postgres instance"
        sleep 5 
	#Start gerrit docker
	docker run \
	--name gerrit \
	--link pg-gerrit:db \
	-p 8080:8080 \
	-p 29418:29418 \
	-e DATABASE_TYPE=postgresql \
	-d waynec/gerrit 
        echo "Started gerrit instance"
        echo "Gerrit is now running on http://127.0.0.1:8080/"
}
# Restart the service FOO
stop() {
        docker rm -f gerrit
        echo "Stopped Gerrit Instance"
        docker rm -f pg-gerrit
        echo "Stopped Gerrit" 
}

destroy() {
        docker rmi -f waynec/postgres
        docker rmi -f waynec/gerrit
}
### main logic ###
case "$1" in
  start)
        check_docker_images
        start
        ;;
  stop)
        stop
        ;;
  rebuild)
        rebuild 
        ;;
  destroy)
        stop
        destroy
	;;
  restart|reload|condrestart)
        stop
        start
        ;;
  status)
	status
	;;	
  logs)
	getlogs
 	;;
  snapshot)
	snapshot
	;;
  listsnapshots)
	listsnapshot
	;;
	
       
  *)
        echo $"Usage: $0 {start|stop|restart|reload|status|rebuild|destroy|logs|snapshot|listsnapshots}"
        exit 1
esac
exit 0
