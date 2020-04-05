lock '3.11.1'

set :application, 'eolien'
set :repo_url, 'git@ct-lucas:seb/eolien.git'

set :deploy_to, '/home/deploy/eolien'

append :linked_files, '.env.local'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'