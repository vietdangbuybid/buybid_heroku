# This migration comes from spree_buybid_core (originally 20190521061313)
class SetDefaultIsDeletedToBuybidSellers < ActiveRecord::Migration[5.2]
  def up
    change_column_default :buybid_sellers, :is_deleted, false
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Cannot remove the default!'
  end
end
