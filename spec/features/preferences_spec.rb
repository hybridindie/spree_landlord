require 'spec_helper'

describe 'preferences' do
  extend AuthorizationHelpers::Request
  stub_authorization!

  let!(:alpha_tenant) { FactoryGirl.create(:tenant, :shortname => 'alpha') }
  let!(:beta_tenant) { FactoryGirl.create(:tenant, :shortname => 'beta') }

  it 'preferences that are set through the admin ui respect tenancy' do
    Rails.cache.clear

    visit 'http://alpha.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"

    find("#site_name").value.should == "Spree Demo Site"

    fill_in "site_name", :with => "Spree Demo Alpha"
    click_button "Update"

    assert_successful_update_message(:general_settings)
    find("#site_name").value.should == "Spree Demo Alpha"

    visit 'http://beta.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"

    find("#site_name").value.should == "Spree Demo Site"

    fill_in "site_name", :with => "Spree Demo Beta"
    click_button "Update"

    assert_successful_update_message(:general_settings)
    find("#site_name").value.should == "Spree Demo Beta"

    visit 'http://alpha.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"

    find("#site_name").value.should == "Spree Demo Alpha"

    visit 'http://beta.sample.com/admin'
    click_link "Configuration"
    click_link "General Settings"

    find("#site_name").value.should == "Spree Demo Beta"
  end

end
