$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rate_limiter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rate_limiter"
  s.version     = RateLimiter::VERSION
  s.authors     = ["Mateus Couto"]
  s.email       = ["mateux@gmail.com"]
  s.homepage    = "localhost:3000"
  s.summary     = "Engine that limits request."
  s.description = "Engine that limits request."
  s.license     = "PRIVATE"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "redis"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
  s.add_development_dependency 'rspec-rails', '~> 3.6'
end
