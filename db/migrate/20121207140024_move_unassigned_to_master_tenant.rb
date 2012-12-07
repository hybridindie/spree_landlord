class MoveUnassignedToMasterTenant < ActiveRecord::Migration
  def up
    migrator = Spree::SpreeLandlord::TenantMigrator.new
    migrator.move_unassigned_to_master
  end
end
