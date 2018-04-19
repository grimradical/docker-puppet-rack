# Configuration file for Unicorn (not Rack)
#
# See https://bogomips.org/unicorn/Unicorn/Configurator.html for complete
# documentation.

require 'etc'
worker_processes (2 * Etc.nprocessors)
listen 8140, :tcp_nopush => true
preload_app true
check_client_connection false
run_once = true
