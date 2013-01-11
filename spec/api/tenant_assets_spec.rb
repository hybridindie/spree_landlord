require 'spec_helper'
require 'fileutils'
require 'sass/css'

describe 'tenant assets' do
  def read_test_app_fixture_file(path)
    app_fixture_root = File.expand_path('../../test_app_fixtures', __FILE__)
    full_path = File.join(app_fixture_root, path)
    File.read(full_path)
  end

  before do
    master = Spree::Tenant.master
    master.shortname = 'example'
    master.domain = 'example.com'
    master.save!

    Spree::Tenant.create!(:shortname => 'apple', :domain => 'apple.com')
  end

  describe 'file retrieval' do
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

    it 'falls back to app asset directory from example tenant' do
      css = read_test_app_fixture_file('app/assets/stylesheets/app.css')

      get 'http://example.com/tenants/example/assets/app.css'

      response.body.should == css
    end

    it 'falls back to app asset directory from apple tenant' do
      css = read_test_app_fixture_file('app/assets/stylesheets/app.css')

      get 'http://example.com/tenants/apple/assets/app.css'

      response.body.should == css
    end

    context 'with scss require' do

      def remove_css_comments_and_new_lines(value)
        value.gsub(/\/\*([^\*]|\*[^\/])*\*\//m, '').gsub("\n", '')
      end

      it 'searches for required file in tenant tree' do
        css = read_test_app_fixture_file('app/tenants/apple/assets/stylesheets/tenant_colors.css.scss')
        sanitized_css = remove_css_comments_and_new_lines(Sass::CSS.new(css).render(:scss))

        get 'http://example.com/tenants/apple/assets/require_from_tenant.css'

        sanitized_body = remove_css_comments_and_new_lines(response.body)
        sanitized_body.should == sanitized_css
      end

      it 'searches for required file in app tree' do
        css = read_test_app_fixture_file('app/assets/stylesheets/app_colors.css.scss')
        sanitized_css = remove_css_comments_and_new_lines(Sass::CSS.new(css).render(:scss))

        get 'http://example.com/tenants/apple/assets/require_from_app.css'

        sanitized_body = remove_css_comments_and_new_lines(response.body)
        sanitized_body.should == sanitized_css
      end

      it 'searches for file from included gem' do
        get 'http://example.com/tenants/apple/assets/require_normalize.css'

        response.body.should_not include('Error compiling CSS asset')
      end
    end
  end

  describe 'helper methods' do
    describe '#javascript_include_tag' do
      it 'generates include tag with path to master tenant javascript' do
        get 'http://example.com/views/javascript_include_tag_fixture'

        response.body.should include(%q{javascript_include_tag('test.js'): <script src="/tenants/example/assets/test.js" type="text/javascript"></script>})
      end

      it 'generates include tag with path to apple tenant javascript' do
        get 'http://apple.com/views/javascript_include_tag_fixture'

        response.body.should include(%q{javascript_include_tag('test.js'): <script src="/tenants/apple/assets/test.js" type="text/javascript"></script>})
      end
    end

    describe '#stylesheet_link_tag' do
      it 'generates link tag with path to master tenant stylesheet' do
        get 'http://example.com/views/stylesheet_link_tag_fixture'

        response.body.should include(%q{stylesheet_link_tag('test.css'): <link href="/tenants/example/assets/test.css" media="screen" rel="stylesheet" type="text/css" />})
      end

      it 'generates link tag with path to apple tenant stylesheet' do
        get 'http://apple.com/views/stylesheet_link_tag_fixture'

        response.body.should include(%q{stylesheet_link_tag('test.css'): <link href="/tenants/apple/assets/test.css" media="screen" rel="stylesheet" type="text/css" />})
      end
    end

    describe '#asset_path' do
      it 'returns path to master tenant asset' do
        get 'http://example.com/views/asset_path_fixture'

        response.body.should include("asset_path('test.css'): /tenants/example/assets/test.css")
      end

      it 'returns path to apple tenant asset' do
        get 'http://apple.com/views/asset_path_fixture'

        response.body.should include("asset_path('test.css'): /tenants/apple/assets/test.css")
      end
    end

    describe '#image_path' do
      it 'returns path to master tenant image' do
        get 'http://example.com/views/image_path_fixture'

        response.body.should include("image_path('test.png'): /tenants/example/assets/test.png")
      end

      it 'returns path to apple tenant image' do
        get 'http://apple.com/views/image_path_fixture'

        response.body.should include("image_path('test.png'): /tenants/apple/assets/test.png")
      end
    end

    describe '#font_path' do
      it 'returns path to master tenant font' do
        get 'http://example.com/views/font_path_fixture'

        response.body.should include("font_path('test.ttf'): /tenants/example/assets/test.ttf")
      end

      it 'returns path to apple tenant font' do
        get 'http://apple.com/views/font_path_fixture'

        response.body.should include("font_path('test.ttf'): /tenants/apple/assets/test.ttf")
      end
    end

    describe '#javascript_path' do
      it 'returns path to master tenant javascript' do
        get 'http://example.com/views/javascript_path_fixture'

        response.body.should include("javascript_path('test.js'): /tenants/example/assets/test.js")
      end

      it 'returns path to apple tenant javascript' do
        get 'http://apple.com/views/javascript_path_fixture'

        response.body.should include("javascript_path('test.js'): /tenants/apple/assets/test.js")
      end
    end

    describe '#stylesheet_path' do
      it 'returns path to master tenant stylesheet' do
        get 'http://example.com/views/stylesheet_path_fixture'

        response.body.should include("stylesheet_path('test.css'): /tenants/example/assets/test.css")
      end

      it 'returns path to apple tenant stlyesheet' do
        get 'http://apple.com/views/stylesheet_path_fixture'

        response.body.should include("stylesheet_path('test.css'): /tenants/apple/assets/test.css")
      end
    end
  end
end
