#!/bin/bash -e
# this script is run during the image build

# delete default config
rm -f /etc/backup-manager.conf

# quick fix
# https://github.com/sukria/Backup-Manager/issues/91
sed "/BM_BMP_PATH/d" /usr/sbin/backup-manager