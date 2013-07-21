class Build < ActiveRecord::Base

  belongs_to :app
  has_one :upload, :class_name => BuildUpload

  attr_accessible :build_number, :release_notes, :version, :app_id, :upload_id

  def plist_url
    #self.upload.file.url.gsub(self.upload.file.file.filename, '') + self.ipa.name + '.plist'
    "/build-#{self.id}.plist"
  end

  def plist_path
    self.upload.file.path.gsub(self.upload.file.file.filename, '') + self.ipa.name + '.plist'
  end

  def ipa
    IpaReader::IpaFile.new(self.upload.file.path)
  end

  def ipa_url
    Rails.configuration.root_domain + self.upload.file.url
  end

  def friendly_create_at
    "#{self.created_at.month}/#{self.created_at.day}/#{self.created_at.year} - " +
    "#{self.created_at.hour}:#{self.created_at.min}#{self.created_at.strftime('%P')}"
  end
end
