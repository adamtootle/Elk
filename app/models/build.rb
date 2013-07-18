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

  def friendly_create_at
    "#{self.created_at.month}/#{self.created_at.day}/#{self.created_at.year} - " +
    "#{self.created_at.hour}:#{self.created_at.min}#{self.created_at.strftime('%P')}"
  end
end
