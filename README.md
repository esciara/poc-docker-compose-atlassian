# poc-docker-compose-atlassian

Docker Compose file to run Atlassian Confluence and Jira Software on one machine, all setup.

```
      confluence.example.com            jira.example.com            
                +                               +
                |                               |
                +-------------------------------+
                               |
                               v
                             Nginx
                               +
                +--------------------------[----+
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

## What is does extra

### Complete setup with database creation

The `docker-compose.yml` instanciate all containers and also creates the postgresql databases at initialisation of the container.

### Further configuration of Confluence (Jira coming soon)

Confluence is further configured and ready to be used (with admin user), thanks 
to a script based on Ruby + Rspec + Capybara + PhantomJS 
(for time being, when containers are newly created only)

### Full volumes backup

A separate container can be instantiated to backup the necessary volumes using 
[Duplicity](http://duplicity.nongnu.org/index.html).

## Requirements

(As tested on Mac OS Sierra)
- Docker version 17.06.2-ce+
- Docker Compose version 1.14.0+

And to run the scripts that setup the atlassian products:
- Ruby 2.4.2
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

The `docker-compose.yml` file in this project has been following the example in 
[https://github.com/blacklabelops/atlassian](https://github.com/blacklabelops/atlassian)

BlackLabelOps' offers full configuration of it's containers through environment variables
(here set put together in `config/atlassian-default.env`). See the above mentioned repo and 
other container repos for more information. 

## Running the docker containers from scratch
How to use:

#####1. Clone the repo:

```
$ git clone https://github.com/esciara/poc-docker-compose-atlassian
```

#####2. Edit the `config/atlassian-default.env` environment file to your liking and source it:

```
$ source config/atlassian-default.env
```
 
#####3. If you are on a development host machine, set the `DNS` according to the confluence and jira domains 
declared in `config/atlassian-default.env`:

``` 
$ vim /etc/hosts
    # you might want to replace `127.0.0.1` with IP of host that `docker-compose` command run on it.
    127.0.0.1 confluence.example.com www.confluence.example.com
    127.0.0.1 jira.example.com       www.jira.example.com
```

#####4. Run docker compose:

```
# if you want to make sure that you really start from a clean sheet 
# !!! CAREFULL: this deletes containers AND volumes
$ docker-compose down -v

# start containers
$ docker-compose up   # or `docker-compose -p atlassian up` if you want to give it a nicer name
```    

Your containers are now running and:
- Confluence should accessible on [http://confluence.example.com](http://confluence.example.com)
- Jira should accessible on [http://jira.example.com](http://jira.example.com)

Or whatever URL you setup in `config/atlassian-default.env`.

#####5. Run the scripts to configure Confluence (Jira coming soon)

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

#####6. Log into Confluence (Jira coming soon)

Now you can connect to Confluence on http://confluence.example.com with user `admin` and password `admin`.

## Setup the backup of the relevant docker volumes

#####1. Edit the `volumerize.env` environment file:

By default:

- `BACKUP_EXTERNAL_VOLUME` is set to the `backup` directory (created if non existant) 
in the directory from which the backup container intialisation script is launched
- `DOCKER_COMPOSE_PROJECT_NAME` is set to `pocdockercomposeatlassian`, which is the default name created by 
Docker Compose from the directory `poc-docker-compose-atlassian` (created when cloning the git repo).
- `TIME_ZONE` is se to `Europe/Paris`
- `VOLUMERIZE_JOBBER_TIME` is set to `0 0 4 * * *` (backing up every day at 4am)
- `VOLUMERIZE_FULL_IF_OLDER_THAN` is set to `7D` (full back up if last full backup older that 7 days)

#####2. Start the backup container

```
$ ./run-volumerize-backup.sh
```

#####3. If you want to backup immediately

```
$ ./exec-volumerize-backup.sh
```

#####4. If you want to restore the last backup (CAREFULL THIS ERASES AND REPLACES THE CURRENT VOLUMES)

```
$ ./run-volumerize-restore.sh
```

# Acknowledgements

This repo is heavily borrowing from [blacklabelops](https://github.com/blacklabelops) and 
[cptactionhank](https://github.com/cptactionhank/) or using code and containers made available by them.

# License

This project is licensed under the terms of the MIT license.