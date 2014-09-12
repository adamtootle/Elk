class CreateDistLists < ActiveRecord::Migration
  def change
    create_table :dist_lists do |t|
      t.integer :app_id

      t.timestamps
    end
  end
end
