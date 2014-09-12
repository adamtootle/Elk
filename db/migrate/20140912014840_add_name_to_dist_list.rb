class AddNameToDistList < ActiveRecord::Migration
  def change
    add_column :dist_lists, :name, :string
  end
end
