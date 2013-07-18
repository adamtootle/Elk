class App < ActiveRecord::Base

  has_many :builds
  has_and_belongs_to_many :users
  
  attr_accessible :name

  def to_param
    self.name
  end
end
