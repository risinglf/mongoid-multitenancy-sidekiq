module Mongoid::Multitenancy::Sidekiq
  class Railtie < Rails::Railtie
    initializer "mongoid-multitenancy.sidekiq" do
      Mongoid::Multitenancy::Sidekiq::Middleware.run
    end
  end
end
