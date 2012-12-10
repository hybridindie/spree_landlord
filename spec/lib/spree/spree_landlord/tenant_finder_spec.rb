require 'spec_helper'
require 'ostruct'

describe Spree::SpreeLandlord::TenantFinder do
  describe '#find_target_tenant' do
    subject(:finder) { Spree::SpreeLandlord::TenantFinder.new }
    before { Spree::Tenant.destroy_all }
    let!(:master) { FactoryGirl.create(:tenant, :shortname => 'master', :domain => 'master.com') }
    let!(:apples) { FactoryGirl.create(:tenant, :shortname => 'apples', :domain => 'apples.com') }
    let!(:oranges) { FactoryGirl.create(:tenant, :shortname => 'oranges', :domain => 'oranges.com') }

    def request(subdomain, domain)
      result = OpenStruct.new
      result.subdomains = [subdomain]
      result.domain = domain
      result
    end

    describe 'test setup' do
      it 'has master set correctly' do
        Spree::Tenant.master.should == master
      end
    end

    describe 'subdomain matching' do
      it 'finds correct tenant' do
        finder.find_target_tenant(request('apples', 'sample.com')).should == apples
      end
    end

    describe 'primary domain matching' do
      it 'permits use of unknown subdomains' do
        finder.find_target_tenant(request('www', 'apples.com')).should == apples
      end

      it 'ignores known subdomains' do
        finder.find_target_tenant(request('oranges', 'apples.com')).should == apples
      end
    end

    describe 'subdomains on master domain' do
      it 'permits use of unknown subdomains' do
        finder.find_target_tenant(request('www', 'master.com')).should == master
      end

      it 'honors known subdomain' do
        finder.find_target_tenant(request('apples', 'master.com')).should == apples
      end
    end

    it 'raises exception if no matching tenant is found' do
      expect {
        finder.find_target_tenant(request('www', 'sample.com'))
      }.to raise_error(Spree::SpreeLandlord::TenantNotFound, "No tenant could be found for 'www.sample.com'")
    end
  end
end
