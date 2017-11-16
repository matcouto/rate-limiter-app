Rails.application.routes.draw do

  mount RateLimiter::Engine => "/rate_limiter"
  get :home, controller: "dummy", action: 'index'
  get :login, controller: "dummy", action: 'login'
end
