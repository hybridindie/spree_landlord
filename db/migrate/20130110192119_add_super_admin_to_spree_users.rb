class AddSuperAdminToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :super_admin, :boolean
  end
end
