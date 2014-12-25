require 'spec_helper'

RSpec.describe SnowmanIO::API, type: :feature do
  before do
    @old_app = Capybara.app
    Capybara.app = SnowmanIO::API
  end

  after do
    Capybara.app = @old_app
  end

  it "unpacking" do
    # 1. go to main page
    visit "/"
    expect(current_path).to eq("/unpacking")

    # check base url setting
    expect(SnowmanIO.store.base_url).to eq("http://www.example.com")

    # 2. create admin password
    fill_in "password", with: "secret"
    click_button "Set Admin Password"
    expect(current_path).to eq("/")

    # 3. logout
    visit "/logout"
    expect(current_path).to eq("/login")
  end

  it "authenticates user with right password" do
    register_admin('secret')
    fill_in "password", with: "secret"
    click_button "Login"
    expect(current_path).to eq("/")
  end

  it "demands not empty password" do
    visit "/unpacking"
    fill_in "password", with: ""
    click_button "Set Admin Password"
    expect(page).to have_content("Empty password is not allowed")
  end

  it "rejects wrong password" do
    register_admin('secret')
    fill_in "password", with: "wrong-password"
    click_button "Login"
    expect(page).to have_content("Wrong password")
  end

  it "API: status" do
    register_admin_and_login("secret")
    visit "/api/status"
    expect(JSON.load(page.body)).to eq({
      "notifiers"=>["SnowmanIO::Notifiers::Console"],
      "base_url"=>"http://www.example.com"
    })
  end
end
