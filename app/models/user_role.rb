class UserRole < ActiveRecord::Base
  attr_accessible :role

  belongs_to :user
  belongs_to :app

  ROLES = {
    :tester => "tester",
    :admin => "admin"
  }
end
