require 'spec_helper'

describe API::Users do

  describe "POST api/users" do
    it "allows a user to sign up" do
      user_data = { email: "test@example.com", password: "123" }
      post "api/users", user: user_data

      expect(last_response).to be_successful
      expect(json_response["user"]["email"]).to eq(user_data[:email])
    end
  end

  describe "POST api/users/login" do
    it "allows a user to sign in" do
      user_data = { email: "test@example.com", password: "123" }
      user = User.create!(user_data)
      post "api/users/login", user: user_data

      expect(last_response).to be_successful
      expect(json_response["token"]).to eq(user.authentication_token)
    end
  end
end
