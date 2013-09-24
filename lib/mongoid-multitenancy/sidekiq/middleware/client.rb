module Mongoid::Multitenancy::Sidekiq::Middleware
  class Client
    def call(worker_class, item, queue)
      if Mongoid::Multitenancy.current_tenant
        item['tenant_class'] ||= Mongoid::Multitenancy.current_tenant.class.to_s
        item['tenant_id'] ||= Mongoid::Multitenancy.current_tenant.id.to_s
      end
      yield
    end
  end
end