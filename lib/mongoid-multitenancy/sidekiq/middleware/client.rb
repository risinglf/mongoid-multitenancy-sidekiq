module Mongoid::Multitenancy::Sidekiq::Middleware
  class Client
    def call(worker_class, item, queue)
      item['tenant'] ||= Mongoid::Multitenancy.current_tenant
      yield
    end
  end
end