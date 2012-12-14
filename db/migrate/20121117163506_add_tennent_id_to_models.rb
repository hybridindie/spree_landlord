class AddTennentIdToModels < ActiveRecord::Migration
  def change
    Spree::Landlord.model_names.each do |model|
      table = model.table_name
      unless column_exists?(table.to_sym, :tenant_id)
        add_column table, :tenant_id, :integer
        add_index table, :tenant_id
      end
    end

    # Create the first tenant
    tenant = Spree::Tenant.new
    tenant.domain = "#{Rails.application.class.parent_name.tableize.singularize}.dev"
    tenant.shortname = "#{Rails.application.class.parent_name}"
    tenant.save!

    # Create the Tenant admin
    Spree::Role.create!(name: 'spree_admin')

    puts("Created #{Rails.application.class.parent_name} as default Tenant")
  end
end