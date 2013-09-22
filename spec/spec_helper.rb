$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'coveralls'
Coveralls.wear!

require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'mongoid'
require 'mongoid-multitenancy'
require 'database_cleaner'
require 'mongoid-multitenancy-sidekiq'
require 'sidekiq/testing/inline'


Mongoid.configure do |config|
  config.connect_to "mongoid_multitenancy_sidekiq"
end

DatabaseCleaner.orm = 'mongoid'


RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
