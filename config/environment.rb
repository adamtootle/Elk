# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Elk::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => AppConfig.sendgrid_username,
  :password => AppConfig.sendgrid_password,
  :domain => AppConfig.sendgrid_domain,
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}