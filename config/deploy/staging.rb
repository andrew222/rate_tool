# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{127.0.0.1}
role :web, %w{127.0.0.1}
role :db,  %w{127.0.0.1}

set :ssh_options, {
  port: 22
}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '127.0.0.1', user: 'webspider', roles: %w{web app}

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab do
    on roles(:db) do
      # only works when ssh to server
      execute "cd #{release_path};bundle exec whenever --update-crontab #{fetch(:application)}"
    end
  end

  desc 'Restart app after deploy'
  task :restart do
    on roles(:app) do
      on roles(:app), in: :sequence, wait: 25 do
        execute "sudo monit stop #{fetch(:application)}_1"
        execute "sudo monit start #{fetch(:application)}_1"
        execute "sudo monit stop #{fetch(:application)}_sidekiq"
        execute "sudo monit start #{fetch(:application)}_sidekiq"
      end
    end
  end
  [:stop, :start].each do |action|
    task action do
      on roles(:app) do
        execute "sudo monit #{action} #{fetch(:application)}_1"
        execute "sudo monit #{action} #{fetch(:application)}_sidekiq"
      end
    end
  end

  after :updated, "deploy:stop"
  after :finished, "deploy:start"
end
