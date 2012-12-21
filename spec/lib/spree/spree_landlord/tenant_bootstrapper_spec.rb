require 'spec_helper'

describe Spree::SpreeLandlord::TenantBootstrapper do
  subject(:bootstrapper) { Spree::SpreeLandlord::TenantBootstrapper.new }

  describe '#run' do
    it 'performs operations in the correct order' do
      bootstrapper.should_receive(:create_first_tenant).ordered
      bootstrapper.should_receive(:create_tenants_admin_role).ordered
      bootstrapper.should_receive(:notify).ordered

      bootstrapper.run
    end
  end

  describe '#create_first_tenant' do
    before { Spree::Tenant.destroy_all }

    it 'creates the first tenant' do
      expect {
        bootstrapper.create_first_tenant
      }.to change { Spree::Tenant.count }.from(0).to(1)
    end

    it 'sets #first_tenant to newly created tenant' do
      new_tenant = bootstrapper.create_first_tenant
      bootstrapper.first_tenant.should == new_tenant
    end

    context 'with single word app names' do
      before {
        bootstrapper.stub(:app_name).and_return('Test')
        bootstrapper.create_first_tenant
      }

      it 'sets the tenants domain' do
        Spree::Tenant.first.domain = 'test.dev'
      end

      it 'sets the shortname' do
        Spree::Tenant.first.shortname = 'test'
      end

      it 'sets the tenants name' do
        Spree::Tenant.first.name = 'Test'
      end
    end

    context 'with multi-word app names' do
      before {
        bootstrapper.stub(:app_name).and_return('TestApp')
        bootstrapper.create_first_tenant
      }

      it 'sets the tenants domain' do
        Spree::Tenant.first.domain.should == 'test-app.dev'
      end

      it 'sets the tenants short name' do
        Spree::Tenant.first.shortname.should == 'test-app'
      end

      it 'sets the tenants name' do
        Spree::Tenant.first.name.should == 'Test App'
      end
    end
  end

  describe '#create_tenants_admin_role' do
    it 'creates the role' do
      expect {
        bootstrapper.create_tenants_admin_role
      }.to change { Spree::Role.count }.by(1)
    end

    it 'assigns the role to the first tenant' do
      first_tenant = Spree::Tenant.create!(:domain => 'test.dev', :shortname => 'test', :name => 'Test')
      bootstrapper.stub(:first_tenant).and_return(first_tenant)

      role = bootstrapper.create_tenants_admin_role
      role.tenant_id.should == first_tenant.id
    end
  end

  describe '#notify' do
    context 'with single word app names' do
      it 'displays completion message to stdout' do
        bootstrapper.stub(:app_name).and_return('Test')
        bootstrapper.should_receive(:puts).with("Created test as default Tenant")
        bootstrapper.notify
      end
    end

    context 'with multi-word app names' do
      it 'displays completion message to stdout' do
        bootstrapper.stub(:app_name).and_return('TestApp')
        bootstrapper.should_receive(:puts).with("Created test-app as default Tenant")
        bootstrapper.notify
      end
    end
  end
end
