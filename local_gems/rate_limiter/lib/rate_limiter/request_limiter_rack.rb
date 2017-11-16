module RateLimiter
  class RequestLimiterRack
    attr_reader :redis, :num_max_requests, :expires_in, :paths

    class RateLimiter::IpBlocked < StandardError; end

    def initialize(app, redis = Redis.current)
      @app = app
      @redis = redis
      @paths = ['/', '/home']
    end

    def call(env)
      req = Rack::Request.new(env)
      success_response = @app.call(env)
      return success_response unless path_should_be_restricted(req.path_info)
      RequestLimiter.new(redis).run(req.ip)
      success_response
      rescue RateLimiter::IpBlocked => error
        [429, {}, [error.message]]
    end
    private

    def path_should_be_restricted(req_path_info)
      paths.include? req_path_info
    end
  end

  class RequestLimiter
    def initialize(redis)
      @redis = redis
    end

    def run(request_ip)
      setup_initial_keys(request_ip)
      raise_error_if_ip_is_blocked
      set_key_and_expire_time(@ip_key) if @redis.get(@ip_key).nil?
      @requests_attempts = @redis.incr(@ip_key)
      set_key_and_expire_time(@blocked_ip_key) and raise RateLimiter::IpBlocked, error_message if limit_exceeded?
    end

    def limit_exceeded?
      @requests_attempts > 3
    end

    def raise_error_if_ip_is_blocked
      raise RateLimiter::IpBlocked, error_message if @redis.get(@blocked_ip_key)
    end

    def setup_initial_keys(req_ip)
      @ip_key = "count_#{req_ip}"
      @blocked_ip_key = "blocked_#{req_ip}"
    end

    def set_key_and_expire_time(key)
      @redis.set(key, 0)
      @redis.expire(key, 10)
    end

    def error_message
      "Rate limit exceeded. Try again in #{@redis.ttl(@blocked_ip_key)} seconds"
    end
  end
end
