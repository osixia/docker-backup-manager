#!/bin/bash -e

FIRST_START_DONE="/etc/docker-backup-manager-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # adapt cronjobs file
  sed -i "s|{{ BACKUP_MANAGER_CRON_EXP }}|${BACKUP_MANAGER_CRON_EXP}|g" /container/service/backup-manager/assets/cronjobs

  # config file doesn't exists use bootstrap config if available
  if [ ! -e /etc/backup-manager.conf ]; then
    echo "No /etc/backup-manager.conf provided using image default one"
    if [ ! -e /container/service/backup-manager/assets/backup-manager.conf ]; then
      echo "Error: No default backup-manager.conf found in /container/service/backup-manager/assets/backup-manager.conf"
      exit 1
    else

      ln -s /container/service/backup-manager/assets/backup-manager.conf /etc/backup-manager.conf

      #
      # bootstrap config
      #
      sed -i "s|{{ BACKUP_MANAGER_REPOSITORY }}|${BACKUP_MANAGER_REPOSITORY}|g" /etc/backup-manager.conf
      sed -i "s|{{ BACKUP_MANAGER_TTL }}|${BACKUP_MANAGER_TTL}|g" /etc/backup-manager.conf
      sed -i "s|{{ BACKUP_MANAGER_TARBALL_DIRECTORIES }}|${BACKUP_MANAGER_TARBALL_DIRECTORIES}|g" /etc/backup-manager.conf
      sed -i "s|{{ BACKUP_MANAGER_UPLOAD_METHOD }}|${BACKUP_MANAGER_UPLOAD_METHOD}|g" /etc/backup-manager.conf
      sed -i "s|{{ BACKUP_MANAGER_UPLOAD_HOSTS }}|${BACKUP_MANAGER_UPLOAD_HOSTS}|g" /etc/backup-manager.conf
      sed -i "s|{{ BACKUP_MANAGER_UPLOAD_FTP_USER }}|${BACKUP_MANAGER_UPLOAD_FTP_USER}|g" /etc/backup-manager.conf
      sed -i "s|{{ BACKUP_MANAGER_UPLOAD_FTP_PASSWORD }}|${BACKUP_MANAGER_UPLOAD_FTP_PASSWORD}|g" /etc/backup-manager.conf
      sed -i "s|{{ BACKUP_MANAGER_UPLOAD_TTL }}|${BACKUP_MANAGER_UPLOAD_TTL}|g" /etc/backup-manager.conf

    fi
  fi

  touch $FIRST_START_DONE
fi

exit 0
