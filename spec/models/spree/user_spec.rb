require 'spec_helper'

describe Spree::User do
  let(:alpha_tenant) { FactoryGirl.create(:tenant, :shortname => 'alpha') }
  let(:beta_tenant) { FactoryGirl.create(:tenant, :shortname => 'beta') }

  it 'permits creating two users with the same email address with different tenants' do
    Spree::Tenant.set_current_tenant(alpha_tenant)
    alpha_user = Spree::User.create!(email: 'test@example.com', password: 'spree123')

    Spree::Tenant.set_current_tenant(beta_tenant)
    beta_user = Spree::User.create!(email: 'test@example.com', password: 'spree123')

    expect(alpha_user.email).to eq(beta_user.email)
    expect(alpha_user.id).to_not eq(beta_user.id)
  end

  it 'prevents creating two users with the same email address for the same tenant' do
    Spree::Tenant.set_current_tenant(alpha_tenant)

    Spree::User.create!(email: 'test@example.com', password: 'spree123')
    expect {
      Spree::User.create!(email: 'test@example.com', password: 'spree123')
    }.to raise_error('Validation failed: Email has already been taken')
  end
end
