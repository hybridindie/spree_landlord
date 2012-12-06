require 'spec_helper'

Spree::Landlord.model_names.each do |model_name|

  describe model_name do
    it "#{model_name} should respond to tenant" do
      model = model_name.new
      model.should respond_to(:tenant)
    end

    context 'when a tenant is set' do
      let(:tenant) { FactoryGirl.create(:tenant) }

      before do
        Spree::Tenant.set_current_tenant(tenant)
      end

      it "a new #{model_name} should have the tenant" do
        item = model_name.new
        item.tenant.should == tenant
      end
    end

    context 'when a tenant is not set' do
      it "a new #{model_name} should have the tenant" do
        item = model_name.new
        item.tenant.should == Spree::Tenant.master
      end
    end

    describe 'default scope' do
      it 'delegates to Spree::Tenant.current_tenant_id' do
        Spree::Tenant.stub(:current_tenant_id).and_return(2112)
        model_name.scoped.to_sql.should =~ /tenant_id = 2112/
      end
    end
  end
end
