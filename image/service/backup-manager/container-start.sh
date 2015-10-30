#!/bin/bash -e

FIRST_START_DONE="/etc/docker-backup-manager-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # adapt cronjobs file
  sed -i "s|{{ BACKUP_MANAGER_CRON_EXP }}|${BACKUP_MANAGER_CRON_EXP}|g" /container/service/backup-manager/assets/cronjobs

  echo "link /container/service/backup-manager/assets/backup-manager.conf to /etc/backup-manager.conf"
  ln -s /container/service/backup-manager/assets/backup-manager.conf /etc/backup-manager.conf

  #
  # bootstrap config
  #
  sed -i "s|{{ BACKUP_MANAGER_TTL }}|${BACKUP_MANAGER_TTL}|g" /etc/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_TARBALL_DIRECTORIES }}|${BACKUP_MANAGER_TARBALL_DIRECTORIES}|g" /etc/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_METHOD }}|${BACKUP_MANAGER_UPLOAD_METHOD}|g" /etc/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_HOSTS }}|${BACKUP_MANAGER_UPLOAD_HOSTS}|g" /etc/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_FTP_USER }}|${BACKUP_MANAGER_UPLOAD_FTP_USER}|g" /etc/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_FTP_PASSWORD }}|${BACKUP_MANAGER_UPLOAD_FTP_PASSWORD}|g" /etc/backup-manager.conf
  sed -i "s|{{ BACKUP_MANAGER_UPLOAD_TTL }}|${BACKUP_MANAGER_UPLOAD_TTL}|g" /etc/backup-manager.conf

  # encryption
  if [ "${BACKUP_MANAGER_ENCRYPTION,,}" == "true" ]; then
    sed -i "s|# export BM_ENCRYPTION_METHOD|export BM_ENCRYPTION_METHOD|g" /etc/backup-manager.conf
    sed -i "s|# export BM_ENCRYPTION_RECIPIENT=\"{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}\"|export BM_ENCRYPTION_RECIPIENT=\"{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}\"|g" /etc/backup-manager.conf

    sed -i "s|{{ BACKUP_MANAGER_ENCRYPTION_RECIPIENT }}|${BACKUP_MANAGER_ENCRYPTION_RECIPIENT}|g" /etc/backup-manager.conf
  fi

  touch $FIRST_START_DONE
fi

exit 0
