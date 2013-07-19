class CreateBuildUploads < ActiveRecord::Migration
  def change
    create_table :build_uploads do |t|
      t.integer :build_id
      t.string :file

      t.timestamps
    end
  end
end
