#!/bin/bash
source ./volumerize.env
#export BACKUP_EXTERNAL_VOLUME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/backups
# Stops volumerize_backup container if already exists
docker stop volumerize_backup
# Exit if things don't work out properly from here
set -ex
# Stops containers before backup and restarts them afterwards
# Source volumes are accessed read-only (through tag ':ro')
# Periodic Backups (That's four a clock in the morning Paris time)
# Enforces Full Backups Periodically (Every & Days)
docker run --rm -d \
    --name volumerize_backup \
    -v ${DOCKER_COMPOSE_PROJECT_NAME}_confluence_postgresql_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_confluence_postgresql_volume:ro \
    -v ${DOCKER_COMPOSE_PROJECT_NAME}_jira_postgresql_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_jira_postgresql_volume:ro \
    -v ${DOCKER_COMPOSE_PROJECT_NAME}_confluence_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_confluence_volume:ro \
    -v ${DOCKER_COMPOSE_PROJECT_NAME}_jira_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_jira_volume:ro \
    -v ${DOCKER_COMPOSE_PROJECT_NAME}_nginx_volume:/source/${DOCKER_COMPOSE_PROJECT_NAME}_nginx_volume:ro \
    -v ${DOCKER_COMPOSE_PROJECT_NAME}_ssl_certificates:/source/${DOCKER_COMPOSE_PROJECT_NAME}_ssl_certificates:ro \
    -v ${BACKUP_EXTERNAL_VOLUME}:/backup \
    -e "VOLUMERIZE_SOURCE=/source" \
    -e "VOLUMERIZE_TARGET=file:///backup" \
    -e "VOLUMERIZE_CONTAINERS=${DOCKER_COMPOSE_PROJECT_NAME}_confluence_postgresql_1 ${DOCKER_COMPOSE_PROJECT_NAME}_jira_postgresql_1 ${DOCKER_COMPOSE_PROJECT_NAME}_confluence_1 ${DOCKER_COMPOSE_PROJECT_NAME}_jira_1 ${DOCKER_COMPOSE_PROJECT_NAME}_nginx_1" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e "TZ=${TIME_ZONE}" \
    -e "VOLUMERIZE_JOBBER_TIME=${VOLUMERIZE_JOBBER_TIME}" \
    -e "VOLUMERIZE_FULL_IF_OLDER_THAN=${VOLUMERIZE_FULL_IF_OLDER_THAN}" \
    blacklabelops/volumerize