class Build < ActiveRecord::Base

  mount_uploader :file, BuildUploader

  belongs_to :app

  attr_accessible :build_number, :release_notes, :version, :file
end
