class BuildUpload < ActiveRecord::Base

  mount_uploader :file, BuildUploader
  belongs_to :build

  attr_accessible :file

  after_destroy :remove_id_directory

  protected

  def remove_id_directory
    FileUtils.remove_dir("#{Rails.root}/public/uploads/builds/#{self.id}")
  end
end
