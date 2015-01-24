# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{104.236.177.134}
role :web, %w{104.236.177.134}
role :db,  %w{104.236.177.134}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '104.236.177.134', user: 'andrew', roles: %w{web app}

namespace :deploy do
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
