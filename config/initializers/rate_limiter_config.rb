RateLimiter.configure do |config|
  config.num_max_requests = -> { 3 }
  config.expires_in = -> { 10 }
  config.paths = -> {  ['/', '/home'] }
end
