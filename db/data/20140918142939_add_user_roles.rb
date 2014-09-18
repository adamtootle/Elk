class AddUserRoles < SeedMigration::Migration
  def up
    UserRole.create(:role => "Admin")
    UserRole.create(:role => "Tester")
  end

  def down

  end
end
