require 'rspec'
require 'mocha/setup'
GEM_ROOT = File.expand_path('../../', __FILE__)

puts GEM_ROOT

$:.unshift File.join(GEM_ROOT, 'lib')

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start
end

require 'swrve'

RSpec.configure do |config|
    config.mock_framework = :mocha
end

