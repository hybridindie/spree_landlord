require 'spec_helper'
require 'fileutils'

describe 'tenant assets' do
  def read_test_app_fixture_file(path)
    app_fixture_root = File.expand_path('../../test_app_fixtures', __FILE__)
    full_path = File.join(app_fixture_root, path)
    File.read(full_path)
  end

  before do
    master = Spree::Tenant.master
    master.domain = 'example.com'
    master.save!
  end

  it 'renders simple non-tenant asset' do
    css = read_test_app_fixture_file('app/assets/stylesheets/test.css')

    get 'http://example.com/assets/test.css'

    response.body.should == css
  end

  it 'renders simple tenant asset' do
    css = read_test_app_fixture_file('app/tenants/apple/assets/stylesheets/test.css')

    get 'http://example.com/tenants/apple/assets/test.css'

    response.body.should == css
  end
end
