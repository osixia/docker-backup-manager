FROM osixia/light-baseimage:0.1.2
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Use baseimage's init system.
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/run
CMD ["/container/tool/run"]

# Use baseimage remove-service tool to remove slapd service
# including process and container start files
RUN apt-get -y update \
		&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
			backup-manager gnupg \
		&& /container/tool/install-service-available cron \
		&& rm -f /etc/backup-manager.conf

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script and clean all
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yaml /container/environment/env.yaml

# Set backup data in a data volume
# Must match env var BM_REPOSITORY_ROOT in backup-manager.conf
VOLUME ["/data/backup"]
