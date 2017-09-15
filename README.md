# poc-docker-compose-atlassian
Docker compose file to run Atlassian Jira Software and Confluence on one machine, all setup.

```
jira.example.com   wiki.example.com
       +                   +
       |                   |
       +--------------------
                 |
                 v
               Nginx
                 +
       +--------------------
       |                   |
       v                   v
   Atlassian Jira    Atlassian Confluence
 [host:jira:8080]   [host:confluence:8090]
       +                   +
       |                   |
       +--------------------
                 |
                 v
              Postgres
        [host:database:5432]
                 +
                 |
       +--------------------
       |                   |
       v                   v
   [db:jira]           [db:wiki]
```


Requirements:

- Docker version 17.07.0-ce+
- Docker Compose version 1.16.1+

Docker image source files:

- [cptactionhank/atlassian-jira](https://hub.docker.com/r/cptactionhank/atlassian-jira/)
- [cptactionhank/atlassian-confluence](https://hub.docker.com/r/cptactionhank/atlassian-confluence/)
- [nginx](https://hub.docker.com/_/nginx/)
- [postgres](https://hub.docker.com/_/postgres/)

