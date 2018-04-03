# Sample verbose configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# https://bogomips.org/unicorn/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See https://bogomips.org/unicorn/Unicorn/Configurator.html for complete
# documentation.

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 6

# Since Unicorn is never exposed to outside clients, it does not need to
# run on the standard HTTP port (80), there is no reason to start Unicorn
# as root unless it's from system init scripts.
# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
#working_directory "/path/to/app/current" # available in 0.94.0+

listen 8140, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
#timeout 30

# feel free to point this anywhere accessible on the filesystem
#pid "/var/run/unicorn.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
#stderr_path "/path/to/app/shared/log/unicorn.stderr.log"
#stdout_path "/path/to/app/shared/log/unicorn.stdout.log"

# combine Ruby 2.0.0+ with "preload_app true" for memory savings
preload_app true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

# local variable to guard against running a hook multiple times
run_once = true
