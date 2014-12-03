require 'spec_helper'

RSpec.describe SnowmanIO::VERSION do
  it "contains 3 digits" do
    expect(SnowmanIO::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end
