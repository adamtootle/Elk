class BuildMailer < ActionMailer::Base
  include SendGrid

  default from: AppConfig.sendgrid_from_address

  def new_build_email(build, dist_list)
    raise "build is nil in BuildMailer.new_build_email" unless !build.nil?

    @build = build
    sendgrid_recipients dist_list.users.map(&:email)
    mail :to => build.app.users.first.email, :subject => "#{@build.app.name} #{@build.version} (##{build.build_number}) is now available"
  end
end
