class CreateSpreeTenants < ActiveRecord::Migration
  def change
    create_table :spree_tenants do |t|
      t.string :domain
      t.string :shortname

      t.timestamps
    end
  end
end
