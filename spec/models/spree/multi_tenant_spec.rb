require 'spec_helper'

Spree::Landlord.model_names.each do |model_name|

  describe model_name do

    around(:each) do
      @tenant = FactoryGirl.create(:tenant)
    end

    it "#{model_name} should respond to tenant" do
      model = model_name.new
      model.should respond_to(:tenant)
    end

    it "when a tenant is set a new #{model_name} should have the tenant" do
      item = model_name.new
      item.tenant.should == @tenant
    end

  end

end
