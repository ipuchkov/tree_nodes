class RedisConnector::Redis
  include Singleton

  def set(namespace, primary_key, data)
    connection.hmset("#{namespace}:#{primary_key}", data)
  end

  def keys(namespace)
    connection.keys("#{namespace}:*")
  end

  def get_all(namespace, primary_key)
    connection.hgetall("#{namespace}:#{primary_key}")
  end

  def del(key)
    connection.del(key)
  end

  def connection
    if Rails.env.test?
      @connection ||= Redis.new(host: '127.0.0.1', port: 6379, db: 10)
    else
      @connection ||= Redis.new(host: '127.0.0.1', port: 6379, db: 1)
    end
  end

  def flushdb
    connection.flushdb
  end
end
