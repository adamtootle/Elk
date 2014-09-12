class DistList < ActiveRecord::Base
  attr_accessible :app_id

  belongs_to :app
  has_and_belongs_to_many :users
end
