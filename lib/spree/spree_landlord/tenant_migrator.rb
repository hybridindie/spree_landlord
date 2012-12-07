module Spree
  module SpreeLandlord
    class TenantMigrator
      def move_unassigned_to_master
        master_tenant = Spree::Tenant.master

        Spree::Landlord.model_names.each do |model|
          model.reset_column_information
          model.unscoped.where(:tenant_id => nil).update_all(:tenant_id => master_tenant.id)
        end
      end
    end
  end
end
