# encoding: utf-8

class BuildUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(ipa)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # after :store, :create_plist

  def create_plist(file)
    ipa = IpaReader::IpaFile.new(self.path)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.doc.create_internal_subset(
        'plist',
        "-//Apple//DTD PLIST 1.0//EN",
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
      )
      xml.plist(:version => "1.0") {
        xml.dict {
          xml.key "items"
          xml.array {
            xml.dict {
              xml.key "assets"
              xml.array {
                xml.dict {
                  xml.key "kind"
                  xml.string "software-package"
                  xml.key "url"
                  xml.string Rails.configuration.root_domain + self.url
                }
              }
              xml.key "metadata"
              xml.dict {
                xml.key "bundle-identifier"
                xml.string ipa.bundle_identifier
                xml.key "bundle-version"
                xml.string ipa.version
                xml.key "kind"
                xml.string "software"
                xml.key "title"
                xml.string self.filename
              }
            }
          }
        }
      }
    end
    File.open(model.plist_path, 'w') { |file| file.write(builder.to_xml(:indent => 4, :encoding => 'UTF-8')) }
  end

end
