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
    visit "/"
    expect(current_path).to eq("/")
  end
end
