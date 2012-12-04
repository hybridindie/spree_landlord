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
  end
end
