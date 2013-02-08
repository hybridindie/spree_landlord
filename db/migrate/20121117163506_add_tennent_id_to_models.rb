class AddTennentIdToModels < ActiveRecord::Migration
  def change
    Spree::Landlord.model_names.each do |model|
      table = model.table_name
      unless column_exists?(table.to_sym, :tenant_id)
        add_column table, :tenant_id, :integer
        add_index table, :tenant_id
      end
    end

    Spree::Tenant.connection.schema_cache.clear!
    Spree::Landlord.model_names.each do |model|
      model.reset_column_information
    end

    # Create the first tenant
    tenant = Spree::Tenant.new
    tenant.domain = "#{Rails.application.class.parent_name.tableize.singularize}.dev"
    tenant.shortname = "#{Rails.application.class.parent_name}"
    tenant.save!

    puts("Created #{Rails.application.class.parent_name} as default Tenant")
  end
end
