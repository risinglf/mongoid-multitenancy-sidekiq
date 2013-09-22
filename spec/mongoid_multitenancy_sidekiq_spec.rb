require 'spec_helper'

class Tenant
  include Mongoid::Document
end

class User
  include Mongoid::Document
  include Mongoid::Multitenancy::Document

  tenant(:tenant, :optional => true)
end

class UserCreatorWorker
  include Sidekiq::Worker

  def perform
    User.create(tenant: Mongoid::Multitenancy.current_tenant)
  end
end

describe UserCreatorWorker do
  context 'when the current Tenant is set' do
    before do
      @current_tenant = Mongoid::Multitenancy.current_tenant = Tenant.create!
    end

    it 'creates the User with the current tenant_id field' do
      UserCreatorWorker.perform_async
      User.where(tenant_id: @current_tenant.id).should have(1).items
    end
  end

  context 'when the Tenant is not set' do
    before { Mongoid::Multitenancy.current_tenant = nil }

    it 'creates the User without the tenant_id field' do
      UserCreatorWorker.perform_async
      User.where(:tenant_id.ne => '', :tenant_id.exists => true).should have(0).items
      User.where(tenant_id: nil).should have(1).items
    end
  end
end
