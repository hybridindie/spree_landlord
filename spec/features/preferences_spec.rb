require 'spec_helper'

describe 'preferences' do
  extend AuthorizationHelpers::Request
  stub_authorization!

  let!(:alpha_tenant) { Spree::Tenant.create!(:shortname => 'alpha', :domain => 'alpha.dev') }
  let!(:beta_tenant) { Spree::Tenant.create!(:shortname => 'beta', :domain => 'beta.dev') }

  it 'preferences that are set through the admin ui respect tenancy' do
    Rails.cache.clear

    visit 'http://alpha.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"
    click_link "Edit"

    find("#site_name").value.should == "Spree Demo Site"

    fill_in "site_name", :with => "Spree Demo Alpha"
    click_button "Update"

    page.should have_content('Spree Demo Alpha')
    click_link "Edit"
    find("#site_name").value.should == "Spree Demo Alpha"

    visit 'http://beta.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"
    click_link "Edit"

    find("#site_name").value.should == "Spree Demo Site"

    fill_in "site_name", :with => "Spree Demo Beta"
    click_button "Update"

    page.should have_content('Spree Demo Beta')
    click_link "Edit"
    find("#site_name").value.should == "Spree Demo Beta"

    visit 'http://alpha.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"
    click_link "Edit"

    find("#site_name").value.should == "Spree Demo Alpha"

    visit 'http://beta.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"
    click_link "Edit"

    find("#site_name").value.should == "Spree Demo Beta"
  end

end
