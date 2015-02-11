#!/usr/bin/ruby
# @Author: leopku
# @Date:   2015-01-31 09:26:28
# @Last Modified by:   leopku
# @Last Modified time: 2015-02-11 14:15:41
# environment ENV['RAILS_ENV']
APP_ROOT = File.expand_path('../..', __FILE__)
pidfile "#{APP_ROOT}/tmp/puma.pid"
state_path "#{APP_ROOT}/tmp/puma.state"

bind "unix://#{APP_ROOT}/tmp/puma.sock"

prune_bundler

restart_command 'bundle exec bin/puma'

daemonize true
workers 1
threads 0,4
preload_app!

on_worker_boot do
  require 'active_record'
  config_path = "#{APP_ROOT}/config/database.yml"

  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file(config_path)['production'])
end
