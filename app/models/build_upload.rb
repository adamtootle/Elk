class BuildUpload < ActiveRecord::Base

  mount_uploader :file, BuildUploader
  belongs_to :build

  attr_accessible :file
end
