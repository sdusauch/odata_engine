require File.expand_path("../lib/o_data/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'odata_engine'
  gem.version = OData::VERSION
  gem.date    = Date.today.to_s

  gem.summary = "an awesome gem"
  gem.description = "extended description"

  gem.authors  = ['Simon Dusauchoit']
  gem.email    = 'simon@typework.com'
  gem.homepage = 'http://github.com/sdusauch/odata_engine'

  gem.add_dependency('rake')
  gem.add_development_dependency('rspec', [">= 2.0.0"])

  gem.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  gem.test_files = Dir["test/**/*"]
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", ">= 4.0.0"
end