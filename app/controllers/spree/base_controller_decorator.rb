module Spree
  BaseController.class_eval do

    before_filter :tenant_scope

    private

    def tenant_scope
      tenant = Tenant.current_tenant

      raise 'DomainUnknown' unless tenant

      Proc.new {
        # Add tenant views path
        path = "app/tenants/#{tenant.shortname}/views"
        prepend_view_path(path)

        asset_paths = ["app/tenants/#{tenant.shortname}/assets/images",
                       "app/tenants/#{tenant.shortname}/assets/stylesheets",
                       "app/tenants/#{tenant.shortname}/assets/javascript"]
        asset_paths.each do |path|
          Rails.application.class.assets.prepend_path(path)
        end
      }

    end

  end
end