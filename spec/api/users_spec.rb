require 'spec_helper'

describe API::Users do

  describe "POST api/users" do
    it "allows a user to sign up" do
      user_data = { email: "test@example.com", password: "123" }
      post "api/users", user: user_data

      expect(last_response.status).to eq(201)
      expect(json_response["user"]["email"]).to eq(user_data[:email])
    end
  end
end
