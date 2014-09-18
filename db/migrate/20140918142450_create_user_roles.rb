class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id
      t.integer :app_id
      t.string :role
    end
  end
end
