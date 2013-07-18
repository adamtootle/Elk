class CreateAppsUsersTable < ActiveRecord::Migration
  def up
    create_table :apps_users, :id => false do |t|
        t.references :app
        t.references :user
    end
    add_index :apps_users, [:app_id, :user_id]
    add_index :apps_users, :user_id
  end

  def down
    drop_table :apps_users
  end
end
