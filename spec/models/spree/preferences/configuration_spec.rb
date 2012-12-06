require 'spec_helper'

describe Spree::Preferences::Configuration do
  describe '#preference_cache_key' do
    it 'delegates to Spree::Tenant.current_tenant_id' do
      Spree::Tenant.stub(:current_tenant_id).and_return(88)
      config = Spree::Preferences::Configuration.new
      config.preference_cache_key(:test).should == '88/spree/preferences/configuration/test'
    end
  end
end
