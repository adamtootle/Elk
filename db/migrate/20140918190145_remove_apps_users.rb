class RemoveAppsUsers < ActiveRecord::Migration
  def up
    User.all.each do |user|
        user.apps.each do |app|
          role = UserRole.new
          role.user = user
          role.app = app
          role.role = UserRole::ROLES[:tester]
          role.save
        end
    end

    drop_table :apps_users
  end

  def down
    create_table :apps_users, :id => false do |t|
        t.references :app
        t.references :user
    end
    add_index :apps_users, [:app_id, :user_id]
    add_index :apps_users, :user_id
  end
end
