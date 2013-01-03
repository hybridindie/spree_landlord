require 'spec_helper'

describe 'empty tenant stores' do
  let!(:master_tenant) { Spree::Tenant.master }
  let!(:other_tenant) { FactoryGirl.create(:tenant) }

  before {
    Spree::Product.unscoped.destroy_all
  }

  describe 'visiting empty master tenant' do
    it 'reports no products found' do
      get "http://#{master_tenant.domain}"
      response.body.should include('No products found')
    end
  end

  describe 'visiting empty non-master tenant' do
    it 'reports no products found' do
      get "http://#{other_tenant.domain}"
      response.body.should include('No products found')
    end
  end
end
