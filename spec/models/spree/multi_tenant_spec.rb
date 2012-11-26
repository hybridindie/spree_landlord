require 'spec_helper'

Spree::Landlord.model_names.each do |model_name|
  describe model_name do
    it "#{model_name} should respond to tenant" do
      model = model_name.new
      model.should respond_to(:tenant)
    end
  end
end
