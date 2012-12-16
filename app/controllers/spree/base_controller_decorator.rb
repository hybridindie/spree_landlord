module Spree
  BaseController.class_eval do

    before_filter :tenant_scope

    private

    def tenant_scope
      #tenant = Tenant.current_tenant
      #
      #raise 'DomainUnknown' unless tenant

      # Add tenant views path
      path = "app/tenants/#{Tenant.current_tenant.shortname}/views"
      prepend_view_path(path)

    end

  end
end