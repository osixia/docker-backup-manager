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
  sed -i "s|{{ BACKUP_MANAGER_ARCHIVE_METHOD }}|${BACKUP_MANAGER_ARCHIVE_METHOD}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_TARBALLINC_MASTERDATETYPE }}|${BACKUP_MANAGER_TARBALLINC_MASTERDATETYPE}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_TARBALLINC_MASTERDATEVALUE }}|${BACKUP_MANAGER_TARBALLINC_MASTERDATEVALUE}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf

  # encryption
  if [ "${BACKUP_MANAGER_ENCRYPTION,,}" == "true" ]; then
    sed -i "s|# export BM_ENCRYPTION_METHOD|export BM_ENCRYPTION_METHOD|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    sed -i "s|# export BM_ENCRYPTION_RECIPIENT=\"{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}\"|export BM_ENCRYPTION_RECIPIENT=\"{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}\"|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf

    sed -i "s|{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}|${BACKUP_MANAGER_ENCRYPTION_RECIPIENT}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
  fi


  i=0
  BACKUP_MANAGER_PIPE_COMMAND="BACKUP_MANAGER_PIPE_COMMAND_${i}";
  while [ -n "${!BACKUP_MANAGER_PIPE_COMMAND}" ]; do
    sed -ie "/^# BACKUP MANAGER COMMAND PIPE DATA/i BM_PIPE_COMMAND[$i]=\"${!BACKUP_MANAGER_PIPE_COMMAND}\"" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf

    BACKUP_MANAGER_PIPE_NAME="BACKUP_MANAGER_PIPE_NAME_$i"
    if [ -n "${!BACKUP_MANAGER_PIPE_NAME}" ]; then
      sed -ie "/^# BACKUP MANAGER COMMAND PIPE DATA/i BM_PIPE_NAME[$i]=\"${!BACKUP_MANAGER_PIPE_NAME}\"" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    else
      sed -ie "/^# BACKUP MANAGER COMMAND PIPE DATA/i BM_PIPE_NAME[$i]=\"\"" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    fi

    BACKUP_MANAGER_PIPE_FILETYPE="BACKUP_MANAGER_PIPE_FILETYPE_$i"
    if [ -n "${!BACKUP_MANAGER_PIPE_FILETYPE}" ]; then
      sed -ie "/^# BACKUP MANAGER COMMAND PIPE DATA/i BM_PIPE_FILETYPE[$i]=\"${!BACKUP_MANAGER_PIPE_FILETYPE}\"" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    else
      sed -ie "/^# BACKUP MANAGER COMMAND PIPE DATA/i BM_PIPE_FILETYPE[$i]=\"\"" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    fi

    BACKUP_MANAGER_PIPE_COMPRESS="BACKUP_MANAGER_PIPE_COMPRESS_$i"
    if [ -n "${!BACKUP_MANAGER_PIPE_COMPRESS}" ]; then
      sed -ie "/^# BACKUP MANAGER COMMAND PIPE DATA/i BM_PIPE_COMPRESS[$i]=\"${!BACKUP_MANAGER_PIPE_COMPRESS}\"" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    else
      sed -ie "/^# BACKUP MANAGER COMMAND PIPE DATA/i BM_PIPE_COMPRESS[$i]=\"\"" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf
    fi

    i=$((i+1))
    BACKUP_MANAGER_PIPE_COMMAND="BACKUP_MANAGER_PIPE_COMMAND_${i}";
  done

  sed -i "s|{{ BACKUP_MANAGER_LOGGER_LEVEL }}|${BACKUP_MANAGER_LOGGER_LEVEL}|g" ${CONTAINER_SERVICE_DIR}/backup-manager/assets/backup-manager.conf

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
