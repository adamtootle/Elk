class Build < ActiveRecord::Base

  mount_uploader :file, BuildUploader

  belongs_to :app

  attr_accessible :build_number, :release_notes, :version, :file, :app_id

  def plist_url
    self.file.url.gsub(self.file.file.filename, '') + self.ipa.name + '.plist'
  end

  def plist_path
    self.file.path.gsub(self.file.file.filename, '') + self.ipa.name + '.plist'
  end

  def ipa
    IpaReader::IpaFile.new(self.file.path)
  end
end
