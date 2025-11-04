class ResetMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reset_mailer.send_when_passreset.subject
  #
  def send_when_passreset(email, name)
    @name = name
    mail to: email, subject: "パスワードの再設定"
  end
end
