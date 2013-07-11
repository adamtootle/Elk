class AddAppIdToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :app_id, :integer
  end
end
