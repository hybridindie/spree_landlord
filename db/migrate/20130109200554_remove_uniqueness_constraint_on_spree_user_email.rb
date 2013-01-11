class RemoveUniquenessConstraintOnSpreeUserEmail < ActiveRecord::Migration
  def up
    remove_index :spree_users, :name => 'email_idx_unique'
    add_index :spree_users, :email
  end

  def down
    remove_index :spree_users, :email
    add_index :spree_users, :email, :unique => true, :name => 'email_idx_unique'
  end
end
