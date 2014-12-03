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

    # 2. create admin password
    fill_in "password", with: "secret"
    click_button "Set Admin Password"
    expect(current_path).to eq("/")

    # 3. logout
    visit "/logout"
    expect(current_path).to eq("/login")
  end
end
