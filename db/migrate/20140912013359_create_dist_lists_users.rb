class CreateDistListsUsers < ActiveRecord::Migration
  def up
    create_table :dist_lists_users, :id => false do |t|
        t.references :dist_list
        t.references :user
    end
    add_index :dist_lists_users, [:dist_list_id, :user_id]
    add_index :dist_lists_users, :user_id
  end

  def down
    drop_table :dist_lists_users
  end
end
