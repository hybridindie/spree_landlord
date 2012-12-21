module Spree
  module SpreeLandlord
    class TenantBootstrapper
      def run
        create_first_tenant
        create_tenants_admin_role
      end

      def create_first_tenant
        tenant = Spree::Tenant.new
        tenant.domain = "#{Rails.application.class.parent_name.tableize.singularize}.dev"
        tenant.shortname = "#{Rails.application.class.parent_name}"
        tenant.save!
      end

      def create_tenants_admin_role
        Spree::Role.create!(name: 'spree_admin')
      end

      def notify
        puts("Created #{Rails.application.class.parent_name} as default Tenant")
      end
    end
  end
end
