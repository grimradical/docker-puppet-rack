# What is this?

This repo lets you stand up a Puppet server stack in Docker.

This is unsupported, so caveat emptor and all that.

# Architecture

There is a single container running unicorn and N ruby puppet daemons. This
container should expose port 8140 only to an upstream reverse-proxy. This
container expects a volume mounted into `/etc/puppetlabs/puppet/ssl` that has
appropriate CA, cert, and key material for your installation. The container
expects a volume mounted at `/etc/puppetlabs/code` containing the actual puppet
code for this installation. If you mount a volume at `/puppet-conf` containing
a custom `puppet.conf`, `hiera.yaml`, and/or `auth.conf`, the container will
use those files instead of the defaults.

There is another container running nginx, that handles SSL termination,
reverse-proxying, and load-balancing. Port 8140 on this container can be
exposed to the world; this is the host/port that agents should connect to.
This container expects a volume mounted at `/app` that contains your CA pubkey,
CRL, server cert, and server key.

The `bootstrap-ssl` script will help setup and populate the volumes these
containers need.

The `puppet` script lets you run any puppet subcommand (e.g. `puppet cert
--sign`) against the SSL files contained in the volumes. It spins up a
temporary container with our agent installed, mounts the SSL directory into
`/etc/puppetlabs/ssl`, runs the specified subcommand, then terminates. You can
use this script for care and feeding of the puppet deployment.

There is a docker-compose file in this repo that automatically maps the
required volumes and starts up the containers in the right order.

# Getting started

Build the containers:

    docker-compose build

If you'd like to stand up a master with the name of "puppet", then run:

    ./bootstrap-ssl puppet

This will create a data directory, suitable for use with docker-compose. Check
it:

    find -type f data

Now you can spin things up:

    docker-compose up --build

That should map port 8140 to your docker host.

# Testing it out with a sample agent

Create a server stack with for a hostname of "loadbalancer". This is the name
the docker compose file assigns to the reverse-proxy and DNS is handled
automatically:

    ./bootstrap-ssl loadbalancer
    docker-compose up --build

Now spin up a fresh container that has our agent bits on it:

    docker-compose run puppet /bin/bash

This will run the puppetmaster image, but instead of starting up a master it'll
just startup a shell. In that container, run:

    puppet agent -t --server loadbalancer

This will terminate because the cert hasn't been signed for this new agent.
Because this "agent" container is really just the same container as a master,
complete with read/write access to the SSL directory, we can just sign our cert
ourselves (cue evil music):

    puppet cert sign --all

You can now re-run the agent:

    puppet agent -t --server loadbalancer

...and all should be well. If you want to try actually doing something with
this agent, then on the docker host:

    mkdir -p data/code/environments/production/manifests
    echo 'node default { notify {"Hello":} }' > data/code/environments/production/manifests/site.pp

Now when you run the agent, you should actually see some results. :)

# TODO

There are a ton of ways you can help make this better, with very few things
requiring any hardcore programming knowledge. Please send pull requests! Here
are some areas where we could use help:

#### Hygiene

- [ ] Move images into their own repos (once they're sufficiently baked)
  - [ ] Add in metadata specifications for each

#### PuppetDB

- [ ] Add container for PDB
  - [ ] Port to Alpine linux, to minimize size
- [ ] Modify SSL bootstrap script to also generate cert for the PDB daemon
- [ ] Connect master containers to PDB
   - [ ] Modify master container to include PDB terminus
   - [ ] Modify master container to point at PDB daemon
   - [ ] Make this configurable (using multiple compose files) for those that don't need or want to run PDB
- [ ] Add container for postgres
   - [ ] Add relevant extensions (e.g. pg_trm)
- [ ] _investigate_ Can we use cert-based auth for postgres?

#### Master

- [ ] Environment variable for configuring worker processes
- [ ] Enable override of default environment.conf
- [ ] Enable override of default autosign.conf
- [ ] Enable override of default custom_trusted_oid_mapping.yaml.conf
- [ ] _investigate_ Give masters only minimum SSL data required to run
- [ ] Port to Alpine linux, to minimize size

#### CA

- [ ] Externalize CA into its own container
- [ ] _investigate_ Does the loadbalancer need to proxy/rewrite CA requests?

#### Load balancer

- [ ] Make hostname of upstream configurable (environment vars?)
- [ ] _investigate_ Offload static file serving from Masters
- [ ] _investigate_ Try the nginx Alpine-based image
- [ ] _investigate_ Can we make upstreams dynamic? SRV records? Querying the container runtime?
