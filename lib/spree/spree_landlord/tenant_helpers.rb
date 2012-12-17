module Spree
  module SpreeLandlord
    module TenantHelpers
      extend ActiveSupport::Concern

      included do
        before_filter :set_current_tenant
        before_filter :add_tenant_view_path
        before_filter :add_asset_paths
      end

      def set_current_tenant
        finder = TenantFinder.new
        tenant = finder.find_target_tenant(request)
        Spree::Tenant.set_current_tenant(tenant)
      end

      def add_tenant_view_path
        tenant = Tenant.current_tenant
        path   = "app/tenants/#{tenant.shortname}/views"
        prepend_view_path(path)
      end

      def add_asset_paths
        tenant = Tenant.current_tenant
        asset_paths = ["app/tenants/#{tenant.shortname}/assets/images",
                       "app/tenants/#{tenant.shortname}/assets/stylesheets",
                       "app/tenants/#{tenant.shortname}/assets/javascripts"]
        asset_paths.each do |path|
          Rails.application.class.assets.prepend_path(path)
        end
      end

    end
  end
end
