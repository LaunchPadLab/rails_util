lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_util/version'

Gem::Specification.new do |s|
  s.name        = 'rails_util'
  s.version     = RailsUtil::VERSION
  s.date        = '2017-04-11'
  s.summary     = 'Utility code for Rails apps'
  s.description = 'Utility code for Rails apps'
  s.authors     = ['Dave Corwin']
  s.email       = 'dave@launchpadlab.com'
  s.homepage    = 'https://github.com/launchpadlab/rails_util'
  s.license     = 'None'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  s.add_development_dependency 'rspec'
  s.add_dependency 'activesupport'
end
