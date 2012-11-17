class MoveExistingToMasterTenant < ActiveRecord::Migration
  def change
    # Assign all existing items to the tenant
    Spree::Landlord.model_names.each do |model|
      puts("Updating #{model} with Tenant")
      model.all.each do |item|
        item.update_attribute(:tenant_id, tenant.id)
      end
    end
  end
end
