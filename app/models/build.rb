class Build < ActiveRecord::Base

  mount_uploader :file, BuildUploader

  attr_accessible :build_number, :release_notes, :version, :file
end
