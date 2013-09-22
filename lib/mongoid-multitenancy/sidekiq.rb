require 'mongoid-multitenancy/sidekiq/version'
require 'sidekiq'

module Mongoid
  module Multitenancy
    module Sidekiq
      module Middleware
        autoload :Client, 'mongoid-multitenancy/sidekiq/middleware/client'
        autoload :Server, 'mongoid-multitenancy/sidekiq/middleware/server'

        def self.run
          ::Sidekiq.configure_client do |config|
            config.client_middleware do |chain|
              chain.add Mongoid::Multitenancy::Sidekiq::Middleware::Client
            end
          end

          ::Sidekiq.configure_server do |config|
            config.client_middleware do |chain|
              chain.add Mongoid::Multitenancy::Sidekiq::Middleware::Client
            end

            config.server_middleware do |chain|
              chain.add Mongoid::Multitenancy::Sidekiq::Middleware::Server
            end
          end
        end
      end
    end
  end
end

require 'mongoid-multitenancy/sidekiq/railtie' if defined?(Rails)
