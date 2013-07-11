class AddFileToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :file, :string
  end
end
