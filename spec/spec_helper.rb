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

require 'celluloid'
Celluloid.logger = nil

require 'sidekiq'
require 'sidekiq/cli'
require 'sidekiq/processor'
require 'sidekiq/util'
require 'mongoid-multitenancy-sidekiq'


Sidekiq.logger.level = Logger::ERROR

require 'sidekiq/redis_connection'
REDIS = Sidekiq::RedisConnection.create(:url => "redis://localhost/15", :namespace => 'testfoo')

Mongoid.configure do |config|
  config.connect_to "mongoid_multitenancy_sidekiq"
end

DatabaseCleaner.orm = 'mongoid'

Mongoid::Multitenancy::Sidekiq::Middleware.run

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start

    Celluloid.boot
    @boss = Object.new
    @processor = ::Sidekiq::Processor.new(@boss)

    Sidekiq.redis = REDIS
    Sidekiq.redis { |c| c.flushdb }
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
