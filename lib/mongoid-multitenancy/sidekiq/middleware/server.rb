module Mongoid::Multitenancy::Sidekiq::Middleware
  class Server
    def call(worker_class, item, queue)
      if item['tenant']
        Mongoid::Multitenancy.with_tenant(item['tenant']) do
          yield
        end
      else
        yield
      end
    end
  end
end