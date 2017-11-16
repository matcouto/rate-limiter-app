require "rate_limiter/engine"
require "rate_limiter/configuration"
require "rate_limiter/request_limiter_rack"
require 'redis'

module RateLimiter
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
