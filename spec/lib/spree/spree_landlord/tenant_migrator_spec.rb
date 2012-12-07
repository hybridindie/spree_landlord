require 'spec_helper'

describe Spree::SpreeLandlord::TenantMigrator do
  subject(:migrator) { Spree::SpreeLandlord::TenantMigrator.new }

  describe '#move_unassigned_to_master' do
    it 'moves items no tenant assigned to the master tenant' do
      product = Spree::Product.create!(:name => 'Bagel', :price => 1.99)
      product.tenant_id = nil
      product.save(:validate => false)
      product.tenant_id.should == nil

      migrator.move_unassigned_to_master

      product.reload
      product.tenant_id.should == Spree::Tenant.master.id
    end

    it 'does not move items that are already assigned to a tenant' do
      fake_tenant_id = 92
      product = Spree::Product.create!(:name => 'Bagel', :price => 1.99)
      product.tenant_id = fake_tenant_id
      product.save(:validate => false)
      product.tenant_id.should == fake_tenant_id

      migrator.move_unassigned_to_master

      product.reload
      product.tenant_id.should == fake_tenant_id
    end
  end
end
