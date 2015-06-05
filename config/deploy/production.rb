# configuration for whenever
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

role :app, %w{107.182.178.17}
role :web, %w{107.182.178.17}
role :db,  %w{107.182.178.17}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '107.182.178.17', user: 'andrew', roles: %w{web app}

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{fetch(:application)}"
  end

  desc 'Restart app after deploy'
  task :restart do
    on roles(:app) do
      on roles(:app), in: :sequence, wait: 25 do
        execute "sudo monit stop #{fetch(:application)}_1"
        execute "sudo monit start #{fetch(:application)}_1"
        execute "sudo monit stop #{fetch(:application)}_scheduler"
        execute "sudo monit start #{fetch(:application)}_scheduler"
        execute "sudo monit stop #{fetch(:application)}_resque"
        execute "sudo monit start #{fetch(:application)}_resque"
      end
    end
  end
  [:stop, :start].each do |action|
    task action do
      on roles(:app) do
        execute "sudo monit #{action} #{fetch(:application)}_1"
        execute "sudo monit #{action} #{fetch(:application)}_scheduler"
        execute "sudo monit #{action} #{fetch(:application)}_resque"
      end
    end
  end

  task :add_default_hooks do
    after 'deploy:starting', 'sidekiq:quiet'
    after 'deploy:updated', 'sidekiq:stop'
    after 'deploy:reverted', 'sidekiq:stop'
    after 'deploy:published', 'sidekiq:start'
  end
end

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
