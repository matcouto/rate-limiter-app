module RateLimiter
  class Engine < ::Rails::Engine
    initializer "rate_limiter.middleware" do |app|
      app.config.app_middleware.use RateLimiter::RequestLimiterRack
    end
  end
end
