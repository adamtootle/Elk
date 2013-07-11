class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :version
      t.string :build_number
      t.text :release_notes

      t.timestamps
    end
  end
end
