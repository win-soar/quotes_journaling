require 'rails_helper'

RSpec.describe "Schedulers", type: :request do
  describe "GET /run_daily" do
    it "returns http success" do
      get "/scheduler/run_daily"
      expect(response).to have_http_status(:success)
    end
  end

end
