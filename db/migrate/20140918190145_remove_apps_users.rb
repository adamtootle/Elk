class RemoveAppsUsers < ActiveRecord::Migration
  def up
    User.all.each do |user|
      apps_users = ActiveRecord::Base.connection.execute("SELECT * FROM apps_users WHERE user_id=#{user.id}")
      apps_users.each do |app_user|
        existing_role = UserRole.where(:user_id => user.id, :app_id => app_user['app_id']).first

        if existing_role.nil?
          role = UserRole.new
          role.user = user
          role.app_id = app_user['app_id']
          role.role = UserRole::ROLES[:tester]
          role.save
        end
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
