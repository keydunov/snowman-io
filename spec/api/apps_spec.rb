require 'spec_helper'

describe API::Apps do
  let(:user) { User.create(email: "text@example.com", password: "12345") }
  before { login_as(:user) }

  describe "GET api/apps" do
    it "returns list of apps" do
      get "api/apps"
      expect(last_response.status).to eq(200)
      expect(json_response["apps"].size).to eq(0)
    end
  end
end
