require 'spec_helper'

describe Spree::Admin::UsersController do
  before {
    Spree::Tenant.set_current_tenant apples_tenant
  }

  let!(:apples_tenant) { FactoryGirl.create(:tenant, :shortname => 'apples', :domain => 'apples.com', name: "Apple") }

  let!(:admin_role) { Spree::Role.find_or_create_by_name(:admin) }

  let!(:super_admin) {
    Spree::User.create!(email: 'super@example.com', password: 'spree123').tap do |u|
      u.super_admin = true
      u.spree_roles << admin_role
      u.save!
    end
  }

  let!(:other_super_admin) {
    Spree::User.create!(email: 'other-super@example.com', password: 'spree123').tap do |u|
      u.super_admin = true
      u.spree_roles << admin_role
      u.save!
    end
  }

  let!(:normal_admin) {
    Spree::User.create!(email: 'admin@example.com', password: 'spree123').tap do |u|
      u.spree_roles << admin_role
      u.save!
    end
  }

  let!(:other_normal_admin) {
    Spree::User.create!(email: 'other-admin@example.com', password: 'spree123').tap do |u|
      u.spree_roles << admin_role
      u.save!
    end
  }

  let!(:customer) {
    Spree::User.create!(email: 'customer@example.com', password: 'spree123')
  }

  def sign_in(user)
    post "http://apples.example.com/user/sign_in", :user => { :email => user.email, :password => user.password }
  end

  it 'allows super admin to grant super admin' do
    sign_in(super_admin)
    put "http://apples.example.com/admin/users/#{other_normal_admin.id}", :user => { :super_admin => true }

    response.should be_redirect
    response.redirect_url.should == 'http://apples.example.com/admin/users'

    other_normal_admin.reload.should be_super_admin
  end

  it 'allows super admin to edit super admin' do
    sign_in(super_admin)
    put "http://apples.example.com/admin/users/#{other_super_admin.id}", :user => { :email => 'new-address@example.com' }

    response.should be_redirect
    response.redirect_url.should == 'http://apples.example.com/admin/users'

    other_super_admin.reload.email.should == 'new-address@example.com'
  end

  it 'prevents admin users from granting super admin' do
    sign_in(normal_admin)
    put "http://apples.example.com/admin/users/#{other_normal_admin.id}", :user => { :super_admin => true }

    response.should be_redirect
    response.redirect_url.should == 'http://apples.example.com/unauthorized'

    other_normal_admin.reload.should_not be_super_admin
  end

  it 'prevents customer users from granting super admin' do
    sign_in(customer)
    put "http://apples.example.com/admin/users/#{other_normal_admin.id}", :user => { :super_admin => true }

    response.should be_redirect
    response.redirect_url.should == 'http://apples.example.com/unauthorized'

    other_normal_admin.reload.should_not be_super_admin
  end

  it 'prevents admin users from editing super admin' do
    sign_in(normal_admin)
    put "http://apples.example.com/admin/users/#{other_super_admin.id}", :user => { :email => 'new-address@example.com' }

    response.should be_redirect
    response.redirect_url.should == 'http://apples.example.com/unauthorized'

    other_super_admin.reload.email.should_not == 'new-address@example.com'
  end

  it 'prevents customer users from editing super admin' do
    sign_in(customer)
    put "http://apples.example.com/admin/users/#{other_super_admin.id}", :user => { :email => 'new-address@example.com' }

    response.should be_redirect
    response.redirect_url.should == 'http://apples.example.com/unauthorized'

    other_super_admin.reload.email.should_not == 'new-address@example.com'
  end
end
