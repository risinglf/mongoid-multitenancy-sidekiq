module Mongoid::Multitenancy::Sidekiq::Middleware
  class Server
    def call(worker_class, item, queue)
      if item['tenant_id'] and item['tenant_class']
        tenant = item['tenant_class'].constantize.find item['tenant_id']
        Mongoid::Multitenancy.with_tenant(tenant) do
          yield
        end
      else
        yield
      end
    end
  end
end