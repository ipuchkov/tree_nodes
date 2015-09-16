RSpec.configure do |config|
  config.before(:suite) do
    RedisConnector::Redis.instance.flushdb
  end
end
