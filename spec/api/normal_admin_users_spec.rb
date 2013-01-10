require 'spec_helper'

describe 'normal admin users' do
  let!(:apples_tenant) { FactoryGirl.create(:tenant, :shortname => 'apples', :domain => 'apples.com', name: "Apple") }
  let!(:oranges_tenant) { FactoryGirl.create(:tenant, :shortname => 'oranges', :domain => 'oranges.com', name: "Orange") }

  let(:apples_admin) {
    Spree::User.create!(email: 'apples-admin@example.com', password: 'spree123').tap do |u|
      u.tenant = apples_tenant
      u.save!
    end
  }

  before {
    Spree::Tenant.set_current_tenant apples_tenant
    Spree::Role.find_or_create_by_name(:user)
    Spree::Role.find_or_create_by_name(:admin)
  }

  it 'can log into its assigned tenant' do
    visit 'http://apples.example.com/admin'

    fill_in 'Email', :with => apples_admin.email
    fill_in 'Password', :with => apples_admin.password
    click_button 'Login'

    page.should_not have_content('Invalid email or password')
    page.should have_content("Logged In As: #{apples_admin.email}")
  end

  it 'cannot log into a different tenant' do
    visit 'http://oranges.example.com/admin'

    fill_in 'Email', :with => apples_admin.email
    fill_in 'Password', :with => apples_admin.password
    click_button 'Login'

    page.should have_content('Invalid email or password')
    page.should_not have_content("Logged In As: #{apples_admin.email}")
  end

  it 'cannot change the super admin status of another user'

  it 'can create admin users' do
    visit 'http://apples.example.com/admin/users/new'

    fill_in 'Email', :with => apples_admin.email
    fill_in 'Password', :with => apples_admin.password
    click_button 'Login'

    fill_in 'Email', :with => 'user@example.com'
    fill_in 'Password', :with => 'spree123'
    fill_in 'Password Confirmation', :with => 'spree123'
    check 'user_spree_role_admin'
    click_button 'Create'

    page.should have_content('Listing Users')
    page.should have_content('user@example.com')

    Spree::User.find_by_email('user@example.com').should have_spree_role(:admin)
  end

  it 'can create customer users' do
    visit 'http://apples.example.com/admin/users/new'

    fill_in 'Email', :with => apples_admin.email
    fill_in 'Password', :with => apples_admin.password
    click_button 'Login'

    fill_in 'Email', :with => 'user@example.com'
    fill_in 'Password', :with => 'spree123'
    fill_in 'Password Confirmation', :with => 'spree123'

    check 'user_spree_role_user'
    click_button 'Create'

    page.should have_content('Listing Users')
    page.should have_content('user@example.com')

    user = Spree::User.find_by_email('user@example.com')
    user.should have_spree_role(:user)
    user.should_not have_spree_role(:admin)
  end
end
