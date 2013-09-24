require 'spec_helper'

class FakeActor
  def processor_done(*args)
    nil
  end

  def real_thread(*args)
    nil
  end
end

class TestWorker
  include Sidekiq::Worker

  def perform
  end
end

class Tenant
  include Mongoid::Document
end

UnitOfWork = Struct.new(:queue, :message) do
  def acknowledge
    # nothing to do
  end

  def queue_name
    queue
  end

  def requeue
    # nothing to do
  end
end


describe Mongoid::Multitenancy::Sidekiq::Middleware::Client do
  describe '#call' do
    context 'when Mongoid::Multitenancy.current_tenant is set' do
      before do
        Mongoid::Multitenancy.current_tenant = Tenant.create!
        jid = TestWorker.perform_async
        @job = Sidekiq::Queue.new.find_job(jid)
      end

      it 'adds both tenant class and tenant_id to the item message' do
        expect(@job['tenant_class']).to eq Mongoid::Multitenancy.current_tenant.class.to_s
        expect(@job['tenant_id']).to eq Mongoid::Multitenancy.current_tenant.id.to_s
      end
    end

    context 'when Mongoid::Multitenancy.current_tenant is nil' do
      before do
        Mongoid::Multitenancy.current_tenant = nil
        jid = TestWorker.perform_async
        @job = Sidekiq::Queue.new.find_job(jid)
      end

      it 'does have neither tenant class nor tenant id to the item message' do
        expect(@job['tenant_class']).to be_nil
        expect(@job['tenant_id']).to be_nil
      end
    end
  end
end

describe Mongoid::Multitenancy::Sidekiq::Middleware::Server do
  before do
    actor = FakeActor.new
    @boss.stub(:async).and_return(actor)
  end

  describe '#call' do
    context 'when the messsage has tenant_class and tenant_id' do
      before do
        @tenant1 = Tenant.create!
        @tenant2 = Tenant.create!
        Mongoid::Multitenancy.current_tenant = @tenant1

        jid = TestWorker.perform_async
        Mongoid::Multitenancy.current_tenant = @tenant2 #change the Tenant, but the worker should be starts with @tenant1

        job = Sidekiq::Queue.new.find_job(jid)
        msg = Sidekiq.dump_json(job.item)
        @work = UnitOfWork.new('default', msg)
      end

      it 'yields the Worker with Mongoid::Multitenancy.with_tenant(@tenant1) block' do
        Mongoid::Multitenancy.should_receive(:with_tenant).with(@tenant1)
        @processor.process(@work)
      end
    end

    context 'when the messsage does not have tenant_class and tenant_id' do
      before do
        Mongoid::Multitenancy.current_tenant = nil
        jid = TestWorker.perform_async

        Mongoid::Multitenancy.current_tenant = Tenant.create! #change the Tenant, but the worker should be starts without tenant

        job = Sidekiq::Queue.new.find_job(jid)
        msg = Sidekiq.dump_json(job.item)
        @work = UnitOfWork.new('default', msg)
      end

      it 'does not yield the Worker with Mongoid::Multitenancy.with_tenant block' do
        Mongoid::Multitenancy.should_not_receive(:with_tenant)
        @processor.process(@work)
      end
    end
  end
end