require 'spec_helper'
require 'ostruct'

describe "Configuring via the setup" do

    let(:our_class) { Struct.new(:name) }

    it "should add our class to the tenanted models" do

        Spree::SpreeLandlord.setup do |config|
            config.register_tenanted_model! our_class
        end

        Spree::Landlord.model_names.should include our_class
    end
end
