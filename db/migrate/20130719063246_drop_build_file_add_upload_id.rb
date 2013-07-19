class DropBuildFileAddUploadId < ActiveRecord::Migration
  def up
    remove_column :builds, :file
  end

  def down
    add_column :builds, :file, :string
  end
end
