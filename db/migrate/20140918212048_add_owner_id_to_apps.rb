class AddOwnerIdToApps < ActiveRecord::Migration
  def change
    add_column :apps, :owner_id, :integer
  end
end
