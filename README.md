# poc-docker-compose-atlassian

WORK IN PROGRESS ! => look at the releases.

Docker compose file to run Atlassian Jira Software (not yet) and Confluence on one machine, all setup.

```
          xxx.xxx.xxx.xxx
                 +
                 |
                 |
                 v
               Nginx
                 +
                 |
                 v
       Atlassian Confluence
      [host:confluence:8090]
                 |
                 |
                 v
              Postgres
        [host:database:5432]
                 +
                 |
                 |
                 v
          [db:confluence]
```

##What is does extra

- `docker-compose.yml` creates the postgresql databases at initialisation of the container (and the volume, otherwise scripts in 
`/docker-entrypoint-initdb.d` won't be run)
- there is a script based on Ruby + Rspec + Capybara + PhantomJS setting up the Atlassian products 
(for time being, when newly created)

##Requirements:

- Docker version 17.07.0-ce+
- Docker Compose version 1.16.1+

And to run the scripts that setup the atlassian products:
- Ruby 2.2.3

###Docker image source files

- [cptactionhank/atlassian-jira](https://hub.docker.com/r/cptactionhank/atlassian-jira/)
- [cptactionhank/atlassian-confluence](https://hub.docker.com/r/cptactionhank/atlassian-confluence/)
- [nginx](https://hub.docker.com/_/nginx/)
- [postgres](https://hub.docker.com/_/postgres/)

## Creating a new server from scratch

```
# if you want to make sure that you really start from a clean sheet 
# !!! CAREFULL: this deletes containers AND volumes
bash$ docker-compose down -v

# start containers
bash$ docker-compose up &
```
And if you want to run the script to setup the atlassian products, first make sure the right libraries are
made available:

```
bash$ gem update --system
bash$ gem install bundler
bash$ bundler install
```
Then, launch the scripts:
```
bash$ bundle exec rake
``` 

