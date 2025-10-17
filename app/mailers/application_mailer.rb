class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_SMTP_USER_NAME']
  layout "mailer"
end
