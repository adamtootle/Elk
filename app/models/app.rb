class App < ActiveRecord::Base

  has_many :builds
  has_many :distribution_lists, :class_name => "DistList", :foreign_key => "app_id"
  has_many :roles, :class_name => "UserRole"

  attr_accessible :name

  def users
    UserRole.where(:app_id => self.id).map(&:user)
  end

  def role_for_user user
    role = UserRole.where(:app_id => self.id, :user_id => user.id).first
  end
end
