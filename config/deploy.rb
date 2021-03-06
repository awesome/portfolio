set :application, 'portfolio'
set :repository,  'https://github.com/rilian/portfolio.git'

set :rails_env, 'production'
default_environment['RAILS_ENV'] = 'production'
set :normalize_asset_timestamps, false

set :scm, :git

set :production_server, 'naru.ihdev.net'
role :web, production_server
role :app, production_server
role :db,  production_server, primary: true

# target
set :deploy_to, '/home/rilian/apps/portfolio'
set :svc_dir,   '/home/rilian/service'

set :user,     'rilian'
set :group,    'rilian'
set :use_sudo, false

# use bundler
require 'bundler/capistrano'

# use whenever
set :whenever_command, 'bundle exec whenever'
require 'whenever/capistrano'

# use rvm
# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p194'
set :rvm_type, :user

namespace :rvm do
  task :trust_rvmrc do
    run "echo 'rvm use #{rvm_ruby_string}' > #{current_release}/.rvmrc"
    run "rvm rvmrc trust #{current_release}"
  end
end
after 'deploy', 'rvm:trust_rvmrc'
after 'deploy:finalize_update', 'deploy:config'

# forward ssh auth
ssh_options[:forward_agent] = true

set :unicorn_pid, '/tmp/unicorn-irene-rilian-portfolio.pid'

namespace :deploy do
  desc 'Deploy production configs'
  task :config do
    run <<-CMD
      mkdir -p #{shared_path}/uploads &&
      ln -sf #{shared_path}/uploads #{latest_release}/public/uploads &&
      mkdir -p #{shared_path}/database &&
      ln -sf #{shared_path}/database #{latest_release}/db/shared &&
      mkdir -p #{shared_path}/config &&
      mkdir -p #{shared_path}/app/assets/images &&
      ln -sf #{shared_path}/app/assets/images/watermark.png #{latest_release}/app/assets/images/watermark.png
    CMD
  end

  #desc 'Zero-downtime restart of Unicorn'
  #task :restart, except: { no_release: true } do
  #  run "kill -s USR2 `cat /tmp/unicorn-tapwatch.pid`"
  #end
  #
  #desc 'Start unicorn'
  #task :start, except: { no_release: true } do
  #  run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  #end
  #
  #desc 'Stop unicorn'
  #task :stop, except: { no_release: true } do
  #  run "kill -s QUIT `cat /tmp/unicorn-tapwatch.pid`"
  #end

  desc 'Down-up restart of Unicorn'
  task :restart, except: { no_release: true } do
    run "kill -s HUP `cat #{unicorn_pid}`"
  end

  desc 'Start unicorn'
  task :start, except: { no_release: true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  desc 'Stop unicorn'
  task :stop, except: { no_release: true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
end

after 'deploy:update_code', 'deploy:migrate'
