require 'coveralls'
require 'simplecov'
if ENV['TRAVIS']
  Coveralls.wear!
else
  SimpleCov.start
end

require 'rspec'
require 'mocha/setup'
GEM_ROOT = File.expand_path('../../', __FILE__)
$:.unshift File.join(GEM_ROOT, 'lib')
require 'swrve'

RSpec.configure do |config|
    config.mock_framework = :mocha
end

