require 'rails_helper'

RSpec.describe RateLimiter::RequestLimiterRack, type: :controller do
  include Rack::Test::Methods
  let(:num_max_requests) { 1 }
  let(:expires_in) { 10 }
  let(:app) {
    Rack::Builder.new do
      eval File.read(Rails.root.join('config.ru'))
    end
  }

  before do
    Redis.new.keys.each { |kk| Redis.new.del kk }
    Dir.chdir(Rails.root)
    RateLimiter.configure do |config|
      config.num_max_requests = -> { 3 }
      config.expires_in = -> { 15 }
      config.paths = -> {  ['/home'] }
    end
  end

  it 'succeeds when the requested path is not in the config paths list' do
    (num_max_requests + 2).times { get '/login' }
    expect(last_response.status).to eq 200
  end

  it 'succeeds when the number of requests is lower than the permited limit' do
    num_max_requests.times { get '/home' }
    expect(last_response.status).to eq 200
  end

  it 'fails when the number of requests is higher than the permited limit' do
    (num_max_requests + 1).times { get '/home' }
    expect(last_response.status).to eq 429
    expect(last_response.body).to include('Rate limit exceeded. Try again in')
  end

  class DummyController < ApplicationController
    restrict_dummy :index, :bla

    def index
      render plain: 'Ok'
    end

    def login
      render plain: 'login'
    end
  end
end
