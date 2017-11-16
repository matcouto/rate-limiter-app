class RateLimiterConfigGenerator < Rails::Generators::Base
  desc "Create RateLimiter Initializer"
  def create_rate_limiter_config_file
    create_file "config/initializers/rate_limiter_config.rb", <<-FILE
RateLimiter.configure do |config|
  config.num_max_requests = -> { '3333' }
  config.expires_in = -> { '' }
  config.paths = -> {  ['/'] }
end
    FILE
  end
end
