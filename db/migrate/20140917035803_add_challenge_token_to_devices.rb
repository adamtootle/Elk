class AddChallengeTokenToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :challenge_token, :string
  end
end
