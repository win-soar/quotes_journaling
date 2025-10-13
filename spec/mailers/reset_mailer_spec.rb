require "rails_helper"

RSpec.describe ResetMailer, type: :mailer do
  describe "send_when_passreset" do
    let(:mail) { ResetMailer.send_when_passreset }

    it "renders the headers" do
      expect(mail.subject).to eq("Send when passreset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
