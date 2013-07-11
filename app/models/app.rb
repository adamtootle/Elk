class App < ActiveRecord::Base

  has_many :builds
  
  attr_accessible :name
end
