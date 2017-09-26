#!/bin/bash

read -r -p "Are you sure you want to DELETE AND REPLACE Atlassian directories and databases with last backup data? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo "###################################"
    echo "# Restoring volumes               #"
    echo "###################################"
    source ./volumerize.env
    docker stop volumerize_backup
    set -ex
    # Restore
    docker run --rm \
        -v ${DOCKER_COMPOSE_PROJECT_NAME}_confluence_postgresql_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_confluence_postgresql_volume \
        -v ${DOCKER_COMPOSE_PROJECT_NAME}_jira_postgresql_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_jira_postgresql_volume \
        -v ${DOCKER_COMPOSE_PROJECT_NAME}_confluence_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_confluence_volume \
        -v ${DOCKER_COMPOSE_PROJECT_NAME}_jira_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_jira_volume \
        -v ${DOCKER_COMPOSE_PROJECT_NAME}_nginx_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_nginx_volume \
        -v ${DOCKER_COMPOSE_PROJECT_NAME}_ssl_certificates:/source/${DOCKER_COMPOSE_PROJECT_NAME}_ssl_certificates \
        -v ${BACKUP_EXTERNAL_VOLUME}:/backup:ro \
        -e "VOLUMERIZE_SOURCE=/source" \
        -e "VOLUMERIZE_TARGET=file:///backup" \
        -e "VOLUMERIZE_CONTAINERS=${DOCKER_COMPOSE_PROJECT_NAME}_confluence_postgresql_1 ${DOCKER_COMPOSE_PROJECT_NAME}_jira_postgresql_1 ${DOCKER_COMPOSE_PROJECT_NAME}_confluence_1 ${DOCKER_COMPOSE_PROJECT_NAME}_jira_1 ${DOCKER_COMPOSE_PROJECT_NAME}_nginx_1" \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e "TZ=${TIME_ZONE}" \
        blacklabelops/volumerize restore
#    docker start volumerize_backup
    ./run-volumerize-backup.sh
    echo "###################################"
    echo "# Restoration completed           #"
    echo "###################################"
else
    echo "###################################"
    echo "# Restoration aborted             #"
    echo "###################################"
fi
