#!/bin/bash -e
# this script is run during the image build

# add cron jobs
ln -s /container/service/backup-manager/assets/cronjobs /etc/cron.d/backup-manager
chmod 600 /container/service/backup-manager/assets/cronjobs
