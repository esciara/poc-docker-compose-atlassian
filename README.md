# poc-docker-compose-atlassian

Docker Compose file to run Atlassian Confluence and Jira Software on one machine, all setup
and configured (work in progress).

```
      confluence.example.com            jira.example.com            
                +                               +
                |                               |
                +-------------------------------+
                               |
                               v
                             Nginx
                               +
                +-------------------------------+
                |                               |
                v                               v
       Atlassian Confluence               Atlassian Jira
      [host:confluence:8080]             [host:jira:8090]
                |                               |
                |                               |
                v                               v
             Postgres                        Postgres
[host:confluence_postgresql:5432]  [host:jira_postgresql:5432]
         [db:atlassiandb]                [db:atlassiandb]
```

## What it does extra

### Complete setup with database creation

The `docker-atlassian.yml` file instantiates all needed containers, 
but also creates the postgresql databases at initialisation of the container.

### Further configuration of Confluence and Jira 

Confluence is further configured and ready to be used (with admin user), thanks 
to a script based on Ruby + [Rspec](http://rspec.info) + 
[Capybara](http://teamcapybara.github.io/capybara/) + [PhantomJS](http://phantomjs.org) 
(for time being, when containers are newly created only)

### Full volumes backup

`docker-atlassian-volumerize.yml` creates a stack with a container to backup the atlassian stack 
and another to restore it using [Duplicity](http://duplicity.nongnu.org/index.html).

## Requirements

(As tested on Mac OS Sierra)
- Docker version 17.06.2-ce+
- Docker Compose version 1.14.0+

And to run the scripts that further configure the atlassian products:
- Ruby 2.4.2 (should also run on 2.3)
- PhantomJS 2.1.1

(Checkout the `config/dev-env-setup*.sh` scripts)
 
## Docker image source files

- [blacklabelops/confluence](https://hub.docker.com/r/blacklabelops/confluence/)
- [blacklabelops/jira](https://hub.docker.com/r/blacklabelops/jira/)
- [blacklabelops/nginx](https://hub.docker.com/r/blacklabelops/nginx/)
- [blacklabelops/postgres](https://hub.docker.com/r/blacklabelops/postgres/)

And for the volumes backup:

- [blacklabelops/volumerize](https://hub.docker.com/r/blacklabelops/volumerize/)

## Confluence and Jira containers' configuration

The `docker-atlassian.yml` file has been following the example in 
[https://github.com/blacklabelops/atlassian](https://github.com/blacklabelops/atlassian)

BlackLabelOps' offers full configuration of it's containers through environment variables
(here set put together in `config/atlassian-default.sh`). See the above mentioned repo and 
other container repos for more information. 

## Running the docker containers from scratch
How to use:

#####1. Clone the repo:

```
$ git clone https://github.com/esciara/poc-docker-compose-atlassian
```

#####2. Edit the `config/atlassian-default.sh` environment file to your liking and source it:

```
$ source config/atlassian-default.sh
```

#####3. If you are on a development host machine, set the `DNS` according to the confluence and jira domains declared in `config/atlassian-default.sh`:

``` 
$ vim /etc/hosts
    # you might want to replace `127.0.0.1` with IP of the host on which the `docker-compose` command is run.
    127.0.0.1 confluence.example.com www.confluence.example.com
    127.0.0.1 jira.example.com       www.jira.example.com
```

#####4. Run docker compose:

```
# if you want to make sure that you really start from a clean sheet 
# !!! CAREFULL: this deletes containers AND volumes
$ docker-compose -f compose-atlassian.yml -p ${ATLASSIAN_COMPOSE_PROJECT_NAME} down -v

# start containers
$ docker-compose -f compose-atlassian.yml -p ${ATLASSIAN_COMPOSE_PROJECT_NAME} up -d
```    

Your containers are now running and:
- Confluence should accessible on [http://confluence.example.com](http://confluence.example.com)
- Jira should accessible on [http://jira.example.com](http://jira.example.com)

(or whatever URLs you set up for `CONFLUENCE_DOMAIN_NAME` and `JIRA_DOMAIN_NAME` in `config/atlassian-default.sh`.)

#####5. Run the scripts to configure Confluence and Jira

If you want to run the script to setup the atlassian products, first make sure the right libraries are
made available:

```
$ gem update --system
$ gem install bundler
$ bundler install
```
Then, launch the scripts:
```
$ bundle exec rake
``` 

#####6. Log into Confluence or Jira

Now you can log into Confluence or Jira with user `admin` and password `admin` 
(it is planned in future releases to be able to change this using configuration files).

## Setup the backup of the relevant docker volumes

#####1. Edit the `config/atlassian-default.sh` environment file:

By default:

- `VOLUMERIZE_JOBBER_TIME` is set to `0 0 4 * * *` (backing up every day at 4am)
- `VOLUMERIZE_FULL_IF_OLDER_THAN` is set to `7D` (full back up if last full backup older that 7 days)

#####2. Deploy the backup stack

```
$ docker-compose -f compose-atlassian-volumerize.yml -p ${ATLASSIAN_COMPOSE_PROJECT_NAME}backup up -d
```

#####3. If you want to backup immediately

```
$ docker exec ${ATLASSIAN_COMPOSE_PROJECT_NAME}backup_volumerize_backup backup
```

#####4. If you want to restore the last backup (CAREFULL THIS ERASES AND REPLACES THE CURRENT VOLUMES)

```
$ docker exec ${ATLASSIAN_COMPOSE_PROJECT_NAME}backup_volumerize_restore
```

# Acknowledgements

This repo is heavily borrowing from [blacklabelops](https://github.com/blacklabelops) and 
[cptactionhank](https://github.com/cptactionhank/) or using code and containers made available by them.

# License

This project is licensed under the terms of the MIT license.