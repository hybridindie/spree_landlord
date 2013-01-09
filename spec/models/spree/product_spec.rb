require 'spec_helper'

describe Spree::Product do
  let(:alpha_tenant) { FactoryGirl.create(:tenant, :shortname => 'alpha') }
  let(:beta_tenant) { FactoryGirl.create(:tenant, :shortname => 'beta') }

  it 'scopes permalink validations by tenant' do
    Spree::Tenant.set_current_tenant(alpha_tenant)
    first = Spree::Product.create!(name: 'alpha', price: 12.99, permalink: 'test')

    Spree::Tenant.set_current_tenant(beta_tenant)
    second = Spree::Product.create!(name: 'beta', price: 12.99, permalink: 'test')

    expect(first.permalink).to eq(second.permalink)
  end

  it 'prevents two of the same permalink for a single tenant' do
    Spree::Tenant.set_current_tenant(alpha_tenant)
    first = Spree::Product.create!(name: 'alpha', price: 12.99, permalink: 'test')
    second = Spree::Product.create!(name: 'beta', price: 12.99, permalink: 'test')
    expect(second.permalink).to eq("#{first.permalink}-1")
  end
end
