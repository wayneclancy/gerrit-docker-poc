# Gerrit Docker image
 The Gerrit code review system with PostgreSQL and OpenLDAP integration supported.

## Versions
 openfrontier/gerrit:latest -> 2.11.3

 openfrontier/gerrit:2.10.x -> 2.10.6

 openfrontier/gerrit:2.9.x -> 2.9.4

## Container Quickstart
  1. Initialize and start gerrit.

    `$ docker run -d -p 8080:8080 -p 29418:29418 openfrontier/gerrit`

  2. Open your browser to http://<docker host url>:8080

## Use another container as the gerrit site storage.
  1. Create a volume container.

    `docker run --name gerrit_volume openfrontier/gerrit echo "Gerrit volume container."`

  2. Initialize and start gerrit using volume created above.

    `docker run -d --volumes-from gerrit_volume -p 8080:8080 -p 29418:29418 openfrontier/gerrit`

## Use local directory as the gerrit site storage.
  1. Create a site directory for the gerrit site.

    `mkdir ~/gerrit_volume`

  2. Initialize and start gerrit using the local directory created above.

    `docker run -d -v ~/gerrit_volume:/var/gerrit/review_site -p 8080:8080 -p 29418:29418 openfrontier/gerrit`

## Install plugins on start.
  When calling gerrit init --batch, it is possible to list plugins to be installed with --install-plugin=<plugin_name>. This can be done using the GERRIT_INIT_ARGS environment variable. See [Gerrit Documentation](https://gerrit-documentation.storage.googleapis.com/Documentation/2.11.3/pgm-init.html) for more information.

## Extend this image.
  Similarly to the [Postgres](https://hub.docker.com/_/postgres/) image, if you would like to do additional configuration mid-script, add one or more
  `*.sh` scripts under `/docker-entrypoint-init.d`. This directory is created by default. Scripts in `/docker-entrypoint-init.d` are run after gerrit
  has been initialized, but before any of the gerrit config is customized, allowing you to programmatically override environment variables in entrypoint
  scripts.

## Run dockerized gerrit with dockerized PostgreSQL and OpenLDAP.
#####All attributes in [gerrit.config ldap section](https://gerrit-review.googlesource.com/Documentation/config-gerrit.html#ldap) is supported.

    #Start postgres docker
    docker run \
    --name pg-gerrit \
    -p 5432:5432 \
    -e POSTGRES_USER=gerrit2 \
    -e POSTGRES_PASSWORD=gerrit \
    -e POSTGRES_DB=reviewdb \
    -d postgres
    #Start gerrit docker
    docker run \
    --name gerrit \
    --link pg-gerrit:db \
    -p 8080:8080 \
    -p 29418:29418 \
    -e WEBURL=http://<your.site.url>:8080 \
    -e DATABASE_TYPE=postgresql 
    -e AUTH_TYPE=LDAP \
    -e LDAP_SERVER=<ldap-servername> \
    -e LDAP_ACCOUNTBASE=<ldap-basedn> \
    -d openfrontier/gerrit

## Sample operational scripts
   Sample scripts to create or destroy this Gerrit container are located at [openfrontier/gerrit-docker](https://github.com/openfrontier/gerrit-docker) project.

   A Jenkins docker image with some sample scripts to integrate with this Gerrit image can be found [here](https://registry.hub.docker.com/u/openfrontier/jenkins/).

   There's an [upper project](https://github.com/openfrontier/ci) which privdes sample scripts about how to use this image and a [Jenkins image](https://registry.hub.docker.com/u/openfrontier/jenkins/) to create a Gerrit-Jenkins integration environment.

## Sync timezone with the host server. 
   `docker run -d -p 8080:8080 -p 29418:29418 -v /etc/localtime:/etc/localtime:ro openfrontier/gerrit`

