# http://stackoverflow.com/questions/7504529/how-do-i-add-asset-search-paths-to-sprockets-based-on-a-wildcard-subdomain-in-ra

module Spree
  module SpreeLandlord
    module TenantAssetsResolver
      def call(env)
        finder = TenantFinder.new
        tenant = finder.find_target_tenant(ActionDispatch::Request.new(env))

        begin
          prepend_tenant_asset_paths(tenant)

          # invokes Sprockets::Server#call
          super
        ensure
          remove_tenant_asset_paths(tenant)
        end

      rescue Spree::SpreeLandlord::TenantNotFound
        super
      end

      def tenant_assets_paths(tenant)
        asset_root = File.join(Rails.root, 'app', 'tenants', tenant.shortname, 'assets')

        [
          File.join(asset_root, 'stylesheets'),
          File.join(asset_root, 'javascripts'),
          File.join(asset_root, 'images')
        ]
      end

      def prepend_tenant_asset_paths(tenant)
        expire_index!
        tenant_assets_paths(tenant).each do |path|
          trail.prepend_path(path)
        end
      end

      def remove_tenant_asset_paths(tenant)
        expire_index!
        tenant_assets_paths(tenant).each do |path|
          trail.paths.delete(path)
        end
      end
    end
  end
end
