#!/bin/bash -e

FIRST_START_DONE="/etc/docker-gpg-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then


  if [ "${BACKUP_MANAGER_ENCRYPTION,,}" == "true" ]; then

    echo "Use encryption"

    TEMP_FILE="trusted-key.tmp"

    # add public keys to gpg
    for f in $(find /container/service/gpg/assets/ -type f ! -name 'README.md'); do
      echo "Add key ${f}"
      gpg --import ${f}
    done

    # add recipient key to trusted keys
    echo "Recipient key : ${BACKUP_MANAGER_ENCRYPTION_RECIPIENT}"
    TRUST_VALUE=':6:'
    TRUSTVAR=`gpg --fingerprint ${BACKUP_MANAGER_ENCRYPTION_RECIPIENT}|grep Key|cut -d= -f2|sed 's/ //g'`

    if [ -z "$TRUSTVAR" ]; then
      echo "Error gpg key ${BACKUP_MANAGER_ENCRYPTION_RECIPIENT} not found"
      exit 1
    fi

    echo $TRUSTVAR$TRUST_VALUE >> $TEMP_FILE
    gpg --import-ownertrust $TEMP_FILE

    rm -f $TEMP_FILE

  fi

  touch $FIRST_START_DONE
fi

exit 0
