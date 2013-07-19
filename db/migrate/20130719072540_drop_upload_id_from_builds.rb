class DropUploadIdFromBuilds < ActiveRecord::Migration
  def up
    remove_column :builds, :upload_id
  end

  def down
    add_column :builds, :upload_id, :integer
  end
end
