FROM debian:stretch-slim

ENV DUMB_INIT_VERSION="1.2.1" DISTRO_CODENAME="stretch" PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://apt.puppetlabs.com/puppet5-release-"$DISTRO_CODENAME".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    dpkg -i puppet5-release-"$DISTRO_CODENAME".deb && \
    dpkg -i dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    rm puppet5-release-"$DISTRO_CODENAME".deb dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    apt-get update && \
    apt-get install --no-install-recommends git -y puppet-agent && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install --no-rdoc --no-ri r10k && \
    apt-get update && apt-get -y install make gcc libssl-dev && \
    gem install --no-ri --no-rdoc unicorn rack && \
    apt-get -y remove make gcc libssl-dev && \
    apt-get -y autoremove && \
    puppet config set user root --section master && \
    puppet config set group root --section master && \
    puppet config set always_cache_features true --section master && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists


COPY docker-entrypoint.sh /
COPY config.ru /
COPY unicorn.conf.rb /

EXPOSE 8140

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["unicorn", "-c", "/unicorn.conf.rb", "/config.ru"]

COPY Dockerfile /
