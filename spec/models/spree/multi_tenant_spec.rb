require 'spec_helper'

describe Spree::MultiTenant do
  model_names.each do |model_name|
    it "should respond to tenant" do
      model = model_name.new
      model.should respond_to?(:tenant)
    end
  end
end
