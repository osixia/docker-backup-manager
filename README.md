# osixia/backup-manager

[![Docker Pulls](https://img.shields.io/docker/pulls/osixia/backup-manager.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/osixia/backup-manager.svg)][hub]
[![](https://images.microbadger.com/badges/image/osixia/backup-manager.svg)](http://microbadger.com/images/osixia/backup-manager "Get your own image badge on microbadger.com")

[hub]: https://hub.docker.com/r/osixia/backup-manager/

Latest release: 0.3.0 - Backup Manager 0.7.12.4 - [Changelog](CHANGELOG.md) | [Docker Hub](https://hub.docker.com/r/osixia/backup-manager/) 

**A docker image to run periodically backup-manager.**
> https://github.com/sukria/Backup-Manager

- [Quick start](#quick-start)
- [Beginner Guide](#beginner-guide)
	- [Backup directory and data persistence](#backup-directory-and-data-persistence)
	- [Use your own Backup Manager config](#use-your-own-backup-manager-config)
	- [Fix docker mounted file problems](#fix-docker-mounted-file-problems)
	- [Debug](#debug)
- [Environment Variables](#environment-variables)
	- [Set your own environment variables](#set-your-own-environment-variables)
		- [Use command line argument](#use-command-line-argument)
		- [Link environment file](#link-environment-file)
		- [Make your own image or extend this image](#make-your-own-image-or-extend-this-image)
- [Advanced User Guide](#advanced-user-guide)
	- [Extend osixia/backup-manager:0.3.0 image](#extend-osixiabackup-manager030-image)
	- [Make your own backup-manager image](#make-your-own-backup-manager-image)
	- [Tests](#tests)
	- [Under the hood: osixia/light-baseimage](#under-the-hood-osixialight-baseimage)
- [Security](#security)
- [Changelog](#changelog)

## Quick start

    # Run Backup Manager image
    docker run --volume /host/data:/data-to-backup --detach osixia/backup-manager:0.3.0

## Beginner Guide

### Backup directory and data persistence

Backups are created by default in the directory `/data/backup` that has been declared as a volume, so your backup files are saved outside the container in a data volume.

For more information about docker data volume, please refer to :

> [https://docs.docker.com/userguide/dockervolumes/](https://docs.docker.com/userguide/dockervolumes/)


### Use your own Backup Manager config
This image comes with a backup manager config file that can be easily customized via environment variables for a quick bootstrap,
but setting your own backup-manager.conf is possible. 2 options:

- Link your config file at run time to `/container/service/backup-manager/assets/backup-manager.conf` :

      docker run --volume /data/my-backup-manager.conf:/container/service/backup-manager/assets/backup-manager.conf --detach osixia/backup-manager:0.3.0

- Add your config file by extending or cloning this image, please refer to the [Advanced User Guide](#advanced-user-guide)

### Fix docker mounted file problems

You may have some problems with mounted files on some systems. The startup script try to make some file adjustment and fix files owner and permissions, this can result in multiple errors. See [Docker documentation](https://docs.docker.com/v1.4/userguide/dockervolumes/#mount-a-host-file-as-a-data-volume).

To fix that run the container with `--copy-service` argument :

		docker run [your options] osixia/backup-manager:0.3.0 --copy-service

### Debug

The container default log level is **info**.
Available levels are: `none`, `error`, `warning`, `info`, `debug` and `trace`.

Example command to run the container in `debug` mode:

	docker run --detach osixia/backup-manager:0.3.0 --loglevel debug

See all command line options:

	docker run osixia/backup-manager:0.3.0 --help

## Environment Variables

Environment variables defaults are set in **image/environment/default.yaml**

See how to [set your own environment variables](#set-your-own-environment-variables)

- **BACKUP_MANAGER_ARCHIVE_METHOD**: Archive method, this image allows you to set **tarball** or **tarball-incremental** methods with the following environment variables but all Backup Manager environment variables (starting by *BM_**) can also be set to configure any method you need. Defaults to `tarball`.

- **BACKUP_MANAGER_TARBALL_DIRECTORIES**: Directories to backup: paths without spaces in their name. Defaults to `/data-to-backup /data-to-backup2`.

- **BACKUP_MANAGER_CRON_EXP**: Cron expression to schedule backup-manager execution. Defaults to `0 4 * * *`. Every days at 4am.

- **BACKUP_MANAGER_TTL**: Backup TTL in days. Defaults to `15`.

Upload configuration:

- **BACKUP_MANAGER_UPLOAD_METHOD**: Upload method. Defaults to `ftp`.

- **BACKUP_MANAGER_UPLOAD_HOSTS**: Upload to this ftp hosts. Defaults to `ftp.example.org`.

- **BACKUP_MANAGER_UPLOAD_FTP_USER**: Ftp user. Defaults to `ftp-user`.
- **BACKUP_MANAGER_UPLOAD_FTP_PASSWORD**: Ftp password. Defaults to `ftp-password`.
- **BACKUP_MANAGER_UPLOAD_DESTINATION**: Upload to this ftp directory.  Defaults to `/`.
- **BACKUP_MANAGER_UPLOAD_TTL**: Backup TTL on the ftp hosts in days. Defaults to `60`.

Encryption configuration:

- **BACKUP_MANAGER_ENCRYPTION**: Encrypt backups. Defaults to `false`.
- **BACKUP_MANAGER_ENCRYPTION_RECIPIENT**: GPG recipient. Defaults to `Mike Ross`.

Incremental tarball configuration:
- **BACKUP_MANAGER_TARBALLINC_MASTERDATETYPE**: Which frequency to use for the master tarball? possible values: weekly, monthly. Defaults to `weekly`.

- **BACKUP_MANAGER_TARBALLINC_MASTERDATEVALUE**: Number of the day, in the BACKUP_MANAGER_TARBALLINC_MASTERDATETYPE frequency when master tarballs should be made. Defaults to `1`.

	Examples: you want to make master tarballs every friday:
	BACKUP_MANAGER_TARBALLINC_MASTERDATETYPE="weekly"
	BACKUP_MANAGER_TARBALLINC_MASTERDATEVALUE="5"

	Or every first day of the month:
	BACKUP_MANAGER_TARBALLINC_MASTERDATETYPE="monthly"
	BACKUP_MANAGER_TARBALLINC_MASTERDATEVALUE="1"

Pipe configuration:
- **BACKUP_MANAGER_PIPE_COMMAND_0**: Command
- **BACKUP_MANAGER_PIPE_NAME_0**: Name of command (no mandatory, empty if not set)
- **BACKUP_MANAGER_PIPE_FILETYPE_0**: File type of pipe command (no mandatory, empty if not set)
- **BACKUP_MANAGER_PIPE_COMPRESS_0**: Compress type (no mandatory, empty if not set)

You can add **BACKUP_MANAGER_PIPE_COMMAND_1**, **BACKUP_MANAGER_PIPE_COMMAND_2**... to implement other pipe command.

    Examples: Archive a remote MySQL database through SSH:
    BACKUP_MANAGER_PIPE_COMMAND_0: ssh host -c \\"mysqldump -ufoo -pbar base\\"
    BACKUP_MANAGER_PIPE_NAME_0: base
    BACKUP_MANAGER_PIPE_FILETYPE_0: sql
    BACKUP_MANAGER_PIPE_COMPRESS_0: gzip
    Archive a specific directory, on a remote server through SSH:
    BACKUP_MANAGER_PIPE_COMMAND_1: ssh host -c \\"tar -c -z /home/user\\"
    BACKUP_MANAGER_PIPE_NAME_1: host.home.user
    BACKUP_MANAGER_PIPE_FILETYPE_1: tar.gz

More help: https://raw.githubusercontent.com/sukria/Backup-Manager/master/doc/user-guide.txt

### Set your own environment variables

#### Use command line argument
Environment variables can be set by adding the --env argument in the command line, for example:

	docker run --env BACKUP_MANAGER_TARBALL_DIRECTORIES="/home/billy" \
	--detach osixia/backup-manager:0.3.0

#### Link environment file

For example if your environment file is in :  /data/backup-manager/environment/my-env.yaml

	docker run --volume /data/backup-manager/environment/my-env.yaml:/container/environment/01-custom/env.yaml \
	--detach osixia/backup-manager:0.3.0

Take care to link your environment file to `/container/environment/XX-somedir` (with XX < 99 so they will be processed before default environment files) and not  directly to `/container/environment` because this directory contains predefined baseimage environment files to fix container environment (INITRD, LANG, LANGUAGE and LC_CTYPE).

#### Make your own image or extend this image

This is the best solution if you have a private registry. Please refer to the [Advanced User Guide](#advanced-user-guide) just below.

## Advanced User Guide

### Extend osixia/backup-manager:0.3.0 image

If you need to add your custom TLS certificate, bootstrap config or environment files the easiest way is to extends this image.

Dockerfile example:

    FROM osixia/backup-manager:0.3.0
    MAINTAINER Your Name <your@name.com>

    ADD environment /container/environment/01-custom
    ADD gpg-keys /container/service/gpg/assets
    ADD my-backup-manager.conf /container/service/backup-manager/assets/backup-manager.conf


### Make your own backup-manager image

Clone this project :

	git clone https://github.com/osixia/docker-backup-manager
	cd docker-backup-manager

Adapt Makefile, set your image NAME and VERSION, for example :

	NAME = osixia/backup-manager
	VERSION = 0.2.0

	becomes :
	NAME = billy-the-king/backup-manager
	VERSION = 0.1.0

Add your custom keys, environment files, config ...

Build your image :

	make build

Run your image :

	docker run -d billy-the-king/backup-manager:0.1.0

### Tests

We use **Bats** (Bash Automated Testing System) to test this image:

> [https://github.com/bats-core/bats-core](https://github.com/bats-core/bats-core)

Install Bats, and in this project directory run :

	make test

### Under the hood: osixia/light-baseimage

This image is based on osixia/light-baseimage.
More info: https://github.com/osixia/docker-light-baseimage

## Security
If you discover a security vulnerability within this docker image, please send an email to the Osixia! team at security@osixia.net. For minor vulnerabilities feel free to add an issue here on github.

Please include as many details as possible.

## Changelog

Please refer to: [CHANGELOG.md](CHANGELOG.md)
