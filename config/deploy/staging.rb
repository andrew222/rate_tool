role :app, %w{66.187.71.122}
role :web, %w{66.187.71.122}
role :db,  %w{66.187.71.122}

server '66.187.71.122', user: 'webspider', roles: %w{web app db}
set :ssh_options, {
  port: 22
}

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

  #after :updated, "deploy:stop"
  #after :finished, "deploy:start"
end
