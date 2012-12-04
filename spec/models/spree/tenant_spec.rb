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
end
