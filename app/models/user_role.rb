class UserRole < ActiveRecord::Base
  attr_accessible :role

  belongs_to :user
  belongs_to :app

  ROLES = {
    :admin => "admin",
    :tester => "tester"
  }
end
