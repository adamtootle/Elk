class Build < ActiveRecord::Base
  attr_accessible :build_number, :release_notes, :version
end
