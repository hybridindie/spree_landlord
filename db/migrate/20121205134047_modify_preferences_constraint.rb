class ModifyPreferencesConstraint < ActiveRecord::Migration
  def up
    remove_index :spree_preferences, :key
    add_index :spree_preferences, [:key, :tenant_id], :unique => true
  end

  def down
    remove_index :spree_preferences, [:key, :tenant_id]
    add_index :spree_preferences, :key, :unique => true
  end
end
