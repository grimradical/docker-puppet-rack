#!/bin/bash

if [ -e /puppet-conf/hiera.yaml ]; then
  rm -f /etc/puppetlabs/puppet/hiera.yaml
  ln -s /puppet-conf/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
fi

if [ -e /puppet-conf/auth.conf ]; then
  rm -f /etc/puppetlabs/puppet/auth.conf
  ln -s /puppet-conf/auth.conf /etc/puppetlabs/puppet/auth.conf
fi

if [ -e /puppet-conf/puppet.conf ]; then
  rm -f /etc/puppetlabs/puppet/puppet.conf
  ln -s /puppet-conf/puppet.conf /etc/puppetlabs/puppet/puppet.conf
fi

exec "$@"
