# Preview all emails at http://localhost:3000/rails/mailers/reset_mailer_mailer
class ResetMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/reset_mailer_mailer/send_when_passreset
  delegate :send_when_passreset, to: :ResetMailer
end
