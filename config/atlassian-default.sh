#!/bin/bash

#Docker Stack Settings
#Remember that the docker compose project name is being sanitized with re.sub(r'[^a-z0-9]', '', name.lower())
#See https://github.com/docker/compose/issues/2119
export ATLASSIAN_COMPOSE_PROJECT_NAME=atlassian

#Global Container Settings
export ATLASSIAN_TIME_ZONE=Europe/Paris

#Atlassian Container Settings
export ATLASSIAN_PROXY_PORT=80
export ATLASSIAN_PROXY_SCHEME=http
export ATLASSIAN_POSTGRES_VERSION=9.4.6
export ATLASSIAN_DB=atlassiandb
export ATLASSIAN_DB_USERNAME=atlassiandb
export ATLASSIAN_DB_PASSWORD=atlassiandb
export ATLASSIAN_DB_DELAYED_START=10

#Letsencrypt Settings
export LETSENCRYPT_EMAIL=

#Nginx Reverse Proxy Settings
export ATLASSIAN_NGINX_VERSION=latest
export ATLASSIAN_PORT80_REDIRECT=false
export ATLASSIAN_HTTPS=false
export ATLASSIAN_HTTP=true

#Jira Settings
export JIRA_DOMAIN_NAME=jira.example.com
export JIRA_VERSION=7.5.0
export JIRA_JAVA_OPTIONS=" -Xms1g -Xmx2g"

#Confluence
export CONFLUENCE_DOMAIN_NAME=confluence.example.com
export CONFLUENCE_VERSION=6.4.0
export CONFLUENCE_JAVA_OPTIONS=" -Xms1g -Xmx2g"

#Volumerize
export VOLUMERIZE_JOBBER_TIME="0 0 4 * * *"
export VOLUMERIZE_FULL_IF_OLDER_THAN=7D