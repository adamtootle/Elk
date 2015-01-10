class XmlController < ApplicationController

  require 'active_support/core_ext/hash/conversions'

  layout "xml"

  def mobileconfig

    random_string = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    challenge_token = "#{current_user.id}_#{random_string}"

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.doc.create_internal_subset(
        'plist',
        "-//Apple//DTD PLIST 1.0//EN",
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
      )
      xml.plist(:version => "1.0") {
        xml.dict {
          xml.key "PayloadContent"
          xml.dict {
            xml.key "URL"
            xml.string AppConfig.host + "/register_device"
            xml.key "DeviceAttributes"
            xml.array {
              xml.string "UDID"
              xml.string "IMEI"
              xml.string "ICCID"
              xml.string "VERSION"
              xml.string "PRODUCT"
            }
            xml.key "Challenge"
            xml.string challenge_token
          }
          xml.key "PayloadOrganization"
          xml.string "ElkApp"
          xml.key "PayloadDisplayName"
          xml.string "elkapp.com"
          xml.key "PayloadVersion"
          xml.integer 1
          xml.key "PayloadUUID"
          xml.string "9CF421B3-9853-4454-BC8A-982CBD3C907C"
          xml.key "PayloadIdentifier"
          xml.string "com.elkapp.test"
          xml.key "PayloadDescription"
          xml.key "This temporary profile will be used to find and display your current device's UDID. It will not be stored on your device."
          xml.key "PayloadType"
          xml.string "Profile Service"
        }
      }
    end

    @xml = builder.to_xml.html_safe

    device = Device.new
    device.user_id = current_user.id
    device.challenge_token = random_string
    device.save

  	respond_to do |format|
      format.html { render :content_type => "application/x-apple-aspen-config" }
      format.json { render json: {} }
    end
  end

  def register_device
    start_position = request.body.string.index('<?xml')
    end_position = request.body.string.index('</plist>') + '</plist>'.length

    xml_string = request.body.string[start_position..end_position]
    xml_doc = Nokogiri::XML(xml_string)
    hash = Hash.from_xml(xml_doc.root.children.to_xml)

    index = 0
    device_info = {}
    hash['dict']['key'].each do |key|
      device_info[key] = hash['dict']['string'][index]
      index = index + 1
    end

    challenge_token = device_info['CHALLENGE'].split('_')

    existing_device = Device.where(:UDID => device_info['UDID']).first

    if existing_device.nil?
      challenge_token_device = Device.where(:user_id => challenge_token[0], :challenge_token => challenge_token[1]).first

      if !challenge_token_device.nil?
        challenge_token_device.UDID = device_info['UDID']
        challenge_token_device.model = device_info['PRODUCT']
        challenge_token_device.challenge_token = ''
        challenge_token_device.save
      end
    else
      challenge_token_device = Device.where(:user_id => challenge_token[0], :challenge_token => challenge_token[1]).first
      challenge_token_device.destroy
    end

    # this is hacky but it works for now and prevents an error message on the device
    redirect_to "/"
  end

  def plist
    @build = Build.find(params[:id])

    @builder = Nokogiri::XML::Builder.new do |xml|
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
                  xml.string @build.ipa_url
                }
              }
              xml.key "metadata"
              xml.dict {
                xml.key "bundle-identifier"
                xml.string @build.ipa.bundle_identifier + '-ios'
                xml.key "bundle-version"
                xml.string @build.ipa.version
                xml.key "kind"
                xml.string "software"
                xml.key "title"
                xml.string @build.upload.file.file.filename
              }
            }
          }
        }
      }
    end

    puts @builder.to_xml(:indent => 4, :encoding => 'UTF-8')

    respond_to do |format|
      format.html
      format.json { render json: {} }
    end
  end
end
