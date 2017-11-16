require 'rails_helper'

RSpec.describe RateLimiter::Configuration do
  let(:rate_limiter) { RateLimiter.configuration }

  context 'when passing config values via block' do
    before do
      RateLimiter.configure do |config|
        config.num_max_requests = -> { 3 }
        config.expires_in = -> { 15 }
        config.paths = -> {  ['/home', '/login'] }
      end
    end

    specify do
      expect(rate_limiter.num_max_requests).to eq 3
      expect(rate_limiter.expires_in).to eq 15
      expect(rate_limiter.paths).to eq ['/home', '/login']
    end
  end
end
