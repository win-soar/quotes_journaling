require 'rails_helper'

RSpec.describe "LineOmniauths", type: :request do
  describe "GET /callback" do
    it "returns http success" do
      get "/line_omniauth/callback"
      expect(response).to have_http_status(:success)
    end
  end

end
