# osixia/backup-manager

[![](https://badge.imagelayers.io/osixia/backup-manager:latest.svg)](https://imagelayers.io/?images=osixia/backup-manager:latest 'Get your own badge on imagelayers.io')

An image to execute periodicaly backup-manager.

## Quick start

    # Run Backup Manager image
    docker run --volume /host/data:/data-to-backup -d osixia/backup-manager

#### Backup directory and data persitance

Backups are created in the directory `/data/backup` by default that has been declared as a volume, so your backup files are saved outside the container in a data volume.

For more information about docker data volume, please refer to :

> [https://docs.docker.com/userguide/dockervolumes/](https://docs.docker.com/userguide/dockervolumes/)

## Environment Variables

Environement variables defaults are set in **image/env.yaml**. You can modify environment variable values directly in this file and rebuild the image ([see manual build](#manual-build)). You can also override those values at run time with -e argument or by setting your own env.yaml file as a docker volume to `/etc/env.yaml`. See examples below.

- **BACKUP_MANAGER_TARBALL_DIRECTORIES**: Directories to backup: paths without spaces in their name. Defaults to `/data-to-backup /data-to-backup2`.

- **BACKUP_MANAGER_REPOSITORY**: Where to store the archives. Defaults to `/data/backup`.

- **BACKUP_MANAGER_CRON_EXP**: Cron expression to schedule backup-manager execution. Defaults to `"0 4 * * *"`. Every days at 4am.

- **BACKUP_MANAGER_TTL**: Backup TTL in days. Defaults to `15`.

Upload configuration:

- **BACKUP_MANAGER_UPLOAD_METHOD**: Upload method. Defaults to `ftp`.

- **BACKUP_MANAGER_UPLOAD_HOSTS**: Upload to this ftp hosts. Defaults to `ftp.example.org`.

- **BACKUP_MANAGER_UPLOAD_FTP_USER**: Ftp user. Defaults to `ftp-user`.
- **BACKUP_MANAGER_UPLOAD_FTP_PASSWORD**: Ftp password. Defaults to `ftp-password`.
- **BACKUP_MANAGER_UPLOAD_TTL**: Backup TTL on the ftp hosts in days. Defaults to `60`.

Encryption configuration:

- **BACKUP_MANAGER_ENCRYPTION**: Encrypt backups. Defaults to `false`.
- **BACKUP_MANAGER_ENCRYPTION_RECIPIENT**: GPG recipient. Defaults to `Mike Ross`.

More help: https://raw.githubusercontent.com/sukria/Backup-Manager/master/doc/user-guide.txt


### Set environment variables at run time :

Environment variable can be set directly by adding the -e argument in the command line, for example :

	docker run -e BACKUP_MANAGER_TARBALL_DIRECTORIES="/home/billy" -d osixia/backup-manager

Or by setting your own `env.yaml` file as a docker volume to `/etc/env.yaml`

	docker run -v /data/my-env.yaml:/etc/env.yaml \
	-d osixia/backup-manager

## Manual build

Clone this project :

	git clone https://github.com/osixia/docker-backup-manager
	cd docker-backup-manager

Adapt Makefile, set your image NAME and VERSION, for example :

	NAME = osixia/backup-manager
	VERSION = 0.1.0

	becomes :
	NAME = billy-the-king/backup-manager
	VERSION = 0.1.0

Build your image :

	make build

Run your image :

	docker run -d billy-the-king/backup-manager:0.1.0

## Tests

We use **Bats** (Bash Automated Testing System) to test this image:

> [https://github.com/sstephenson/bats](https://github.com/sstephenson/bats)

Install Bats, and in this project directory run :

	make test
