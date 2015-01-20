require 'redis'

$redis = Redis.new YAML.load_file(File.join(File.expand_path('../../..', __FILE__), 'config/redis.yml'))[Rails.env.to_s]