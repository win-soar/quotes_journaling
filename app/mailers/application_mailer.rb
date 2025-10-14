class ApplicationMailer < ActionMailer::Base
  default from: ENV['RESET_MAILER_ADDRESS']
  layout "mailer"
end
