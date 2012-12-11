class AddNameToTenant < ActiveRecord::Migration
  def change
    add_column :spree_tenants, :name, :string
  end
end
