module RateLimiter
  class Configuration
    attr_accessor :num_max_requests, :expires_in, :paths

    def initialize
     @num_max_requests = nil
     @expires_in = nil
     @paths = []
    end

    def num_max_requests
      parse_lambda_value(@num_max_requests)
    end

    def expires_in
      parse_lambda_value(@expires_in)
    end

    def paths
      parse_lambda_value(@paths)
    end

    private

    def parse_lambda_value(value)
      value&.lambda? ? value.() : value
    end
  end
end
