FROM ubuntu:16.04

ENV DUMB_INIT_VERSION="1.2.1" UBUNTU_CODENAME="xenial" PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

RUN apt-get update && \
    apt-get install -y wget=1.17.1-1ubuntu1 && \
    wget https://apt.puppetlabs.com/puppet5-release-"$UBUNTU_CODENAME".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    dpkg -i puppet5-release-"$UBUNTU_CODENAME".deb && \
    dpkg -i dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    rm puppet5-release-"$UBUNTU_CODENAME".deb dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    apt-get update && \
    apt-get install --no-install-recommends git -y puppet-agent && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install --no-rdoc --no-ri r10k && \
    apt-get update && apt-get -y install make gcc libssl-dev && \
    gem install unicorn rack && \
    apt-get -y remove make gcc libssl-dev && \
    puppet config set user root --section master && \
    puppet config set group root --section master && \
    puppet config set always_cache_features true --section master

COPY docker-entrypoint.sh /
COPY config.ru /
COPY unicorn.conf.rb /

EXPOSE 8140

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["unicorn", "-c", "/unicorn.conf.rb", "/config.ru"]

COPY Dockerfile /
