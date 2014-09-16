class AddMenuOrderToApps < ActiveRecord::Migration
  def change
    add_column :apps, :menu_order, :integer
  end
end
