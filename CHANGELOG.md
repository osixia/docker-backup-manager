# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.4.0] - Unreleased
### Added
  - Multiarch support
  - syslog for logging
  - BACKUP_MANAGER_LOGGER_LEVEL environment variable

### Changed
  - Upgrade Backup Manager version to 0.7.14
  - Upgrade baseimage to light-baseimage:1.2.0 (debian buster)
  - make cron job log with /usr/bin/logger -t backup-manager

## [0.3.0] - 2018-01-12
### Added
  - Pipe configuration #2

## [0.2.1] - 2017-10-07
### Added
  - openssh-client and libnet-amazon-s3-perl packages #1

### Changed
  - Upgrade baseimage to light-baseimage:1.1.1

## [0.2.0] - 2017-07-19
### Added
  - Incremental tarball support

### Changed
  - Upgrade Backup Manager version to 0.7.12.4
  - Upgrade baseimage to light-baseimage:1.1.0 (debian stretch)

## [0.1.8] - 2017-03-19
### Changed
    - Upgrade baseimage to light-baseimage:0.2.6

## [0.1.7] - 2016-09-03
### Changed
  - Upgrade baseimage to light-baseimage:0.2.5

## [0.1.6] - 2016-07-26
### Changed
  - Upgrade baseimage to light-baseimage:0.2.4

## [0.1.5] - 2016-02-20
### Changed
  - Upgrade baseimage to light-baseimage:0.2.2

## [0.1.4] - 2016-01-27
### Added
  - Makefile with build no cache

### Changed
  - Upgrade baseimage to light-baseimage:0.2.1

## [0.1.3] - 2015-11-20
### Changed
  - Upgrade baseimage to light-baseimage:0.1.5

## [0.1.2] - 2015-11-19
### Changed
  - Upgrade baseimage to light-baseimage:0.1.4

### Fixed
  - config file

## [0.1.0] - 2015-10-30
Initial release
