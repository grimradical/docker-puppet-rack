#!/bin/bash
confs=(hiera.yaml auth.conf puppet.conf environment.conf autosign.conf custom_trusted_oid_mapping.yaml.conf)

for f in ${confs[*]}; do
  if [ -e /puppet-conf/${f} ]; then
    echo "Overriding default ${f}"
    rm -f /etc/puppetlabs/puppet/${f}
    ln -s /puppet-conf/${f} /etc/puppetlabs/puppet/${f}
  fi
done

exec "$@"
