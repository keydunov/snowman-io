require 'snowman-io'

RSpec.describe 'SnowManIO Version' do
  it "should contain 3 digits" do
    expect(SnowmanIO::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end
