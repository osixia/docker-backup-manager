#!/bin/bash -e
set -o pipefail

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-gpg-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then


  if [ "${BACKUP_MANAGER_ENCRYPTION,,}" == "true" ]; then

    log-helper info "Use encryption..."

    TEMP_FILE="trusted-key.tmp"

    # add public keys to gpg
    for f in $(find ${CONTAINER_SERVICE_DIR}/gpg/assets/ -type f ! -name 'README.md'); do
      log-helper debug "Add key ${f}"
      gpg --import ${f}
    done

    # add recipient key to trusted keys
    log-helper debug "Recipient key : ${BACKUP_MANAGER_ENCRYPTION_RECIPIENT}"
    TRUST_VALUE=':6:'
    TRUSTVAR=`gpg --fingerprint ${BACKUP_MANAGER_ENCRYPTION_RECIPIENT}|grep Key|cut -d= -f2|sed 's/ //g'`

    if [ -z "$TRUSTVAR" ]; then
      log-helper error "Error: gpg key ${BACKUP_MANAGER_ENCRYPTION_RECIPIENT} not found"
      exit 1
    fi

    echo $TRUSTVAR$TRUST_VALUE >> $TEMP_FILE
    gpg --import-ownertrust $TEMP_FILE

    rm -f $TEMP_FILE

  fi

  touch $FIRST_START_DONE
fi

exit 0
