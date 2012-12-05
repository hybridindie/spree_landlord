require 'spec_helper'

describe Spree::Tenant do
  describe '#shortname' do
    it 'converts to lower case on validation' do
      tenant = Spree::Tenant.new
      tenant.shortname = 'SHORTNAME'
      tenant.valid?
      tenant.shortname.should == 'shortname'
    end
  end

  describe '.current_tenant' do
    it 'delegates to current_tenant_id' do
      id = 18
      tenant = mock('tenant')
      Spree::Tenant.stub(:current_tenant_id).and_return(id)
      Spree::Tenant.should_receive(:find).with(id).and_return(tenant)
      Spree::Tenant.current_tenant.should == tenant
    end
  end

  describe '.current_tenant_id' do
    after do
      Thread.current[:tenant_id] = nil
    end

    it 'returns current tenant id stored in the current thread if it exists' do
      Thread.current[:tenant_id] = 12
      Spree::Tenant.current_tenant_id.should == 12
    end

    context 'when current thread has no tenant id' do
      it 'returns the first tenant id' do
        first_tenant = FactoryGirl.create(:tenant)
        second_tenant = FactoryGirl.create(:tenant)
        Spree::Tenant.current_tenant_id.should == first_tenant.id
      end

      it 'raises an exception if there are no tenants' do
        expect {
          Spree::Tenant.current_tenant_id
        }.to raise_error(Spree::SpreeLandlord::MasterTenantMissing, 'At least one tenant is required at all times')
      end
    end
  end

  describe '.set_current_tenant' do
    after do
      Thread.current[:tenant_id] = nil
    end

    let(:tenant) { FactoryGirl.create(:tenant) }

    context 'with an integer' do
      it 'sets the tenant id stored in the current thread' do
        Spree::Tenant.set_current_tenant(tenant.id)
        Thread.current[:tenant_id].should == tenant.id
      end

      it 'ensures that the id provided belongs to an actual tenant' do
        id = -1
        expect {
          Spree::Tenant.set_current_tenant(id)
        }.to raise_error(Spree::SpreeLandlord::TenantNotFound, "No tenant found with id = #{id}")
      end
    end

    context 'with a tenant instance' do
      it 'sets the tenant id stored in the current thread to the tenant instance id' do
        Spree::Tenant.set_current_tenant(tenant)
        Thread.current[:tenant_id].should == tenant.id
      end
    end

    context 'with something else' do
      it 'raises an exception' do
        expect {
          Spree::Tenant.set_current_tenant(:foo)
        }.to raise_error(ArgumentError, 'invalid tenant object or id')
      end
    end
  end
end
