role :app, %w{107.182.178.17}
role :web, %w{107.182.178.17}
role :db,  %w{107.182.178.17}

server '107.182.178.17', user: 'andrew', roles: %w{web app db}

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab do
    on roles(:app) do
      execute "cd #{release_path} && bundle exec whenever --set cron_log=#{release_path}/log/cron_log.log --update-crontab #{fetch(:application)}"
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
