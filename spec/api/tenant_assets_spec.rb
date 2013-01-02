require 'spec_helper'
require 'fileutils'

describe 'tenant assets' do
  def write_file(path, contents)
    full_path = File.join(Rails.root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.open(full_path, 'w') do |f|
      f.write contents
    end
  end

  before do
    master = Spree::Tenant.master
    master.domain = 'example.com'
    master.save!
  end

  it 'renders simple non-tenant asset' do
    css = "p { color: #000; }\n"
    write_file('app/assets/stylesheets/test.css', css)

    get 'http://example.com/assets/test.css'

    response.body.should == css
  end

  it 'renders simple tenant asset' do
    css = "p { color: #000; }\n"
    write_file('app/tenants/apple/assets/test.css', css)

    get 'http://example.com/tenants/apple/assets/test.css'

    response.body.should == css
  end
end
