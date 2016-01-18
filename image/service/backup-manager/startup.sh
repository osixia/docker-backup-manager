#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-backup-manager-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # adapt cronjobs file
  sed -i "s|{{ BACKUP_MANAGER_CRON_EXP }}|${BACKUP_MANAGER_CRON_EXP}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/cronjobs

  #
  # bootstrap config
  #
  sed -i "s|{{ BACKUP_MANAGER_TTL }}|${BACKUP_MANAGER_TTL}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_TARBALL_DIRECTORIES }}|${BACKUP_MANAGER_TARBALL_DIRECTORIES}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_METHOD }}|${BACKUP_MANAGER_UPLOAD_METHOD}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_HOSTS }}|${BACKUP_MANAGER_UPLOAD_HOSTS}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_FTP_USER }}|${BACKUP_MANAGER_UPLOAD_FTP_USER}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_FTP_PASSWORD }}|${BACKUP_MANAGER_UPLOAD_FTP_PASSWORD}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_DESTINATION }}|${BACKUP_MANAGER_UPLOAD_DESTINATION}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_TTL }}|${BACKUP_MANAGER_UPLOAD_TTL}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf

  # encryption
  if [ "${BACKUP_MANAGER_ENCRYPTION,,}" == "true" ]; then
    sed -i "s|# export BM_ENCRYPTION_METHOD|export BM_ENCRYPTION_METHOD|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    sed -i "s|# export BM_ENCRYPTION_RECIPIENT=\"{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}\"|export BM_ENCRYPTION_RECIPIENT=\"{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}\"|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf

    sed -i "s|{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}|${BACKUP_MANAGER_ENCRYPTION_RECIPIENT}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  fi

  touch $FIRST_START_DONE
fi

# add cron jobs
ln -sf ${CONTAINER_SERVICE_DIR}/backup-manager/assets/cronjobs /etc/cron.d/backup-manager
chmod 600 ${CONTAINER_SERVICE_DIR}/backup-manager/assets/cronjobs

if [ ! -e "/etc/backup-manager.conf" ]; then
  log-helper info "Link ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf to /etc/backup-manager.conf ..."
  ln -sf ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf /etc/backup-manager.conf
fi

exit 0
