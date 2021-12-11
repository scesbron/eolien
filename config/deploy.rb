lock '3.16.0'

set :application, 'eolien'
set :repo_url, 'git@github.com:scesbron/eolien.git'

set :deploy_to, '/home/deploy/eolien'

append :linked_files, '.env.local'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'
