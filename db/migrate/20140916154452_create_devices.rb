class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.string :UDID
      t.string :model

      t.timestamps
    end
  end
end
