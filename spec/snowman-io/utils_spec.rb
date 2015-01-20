require 'spec_helper'

RSpec.describe SnowmanIO::Utils, type: :feature do
  it "stats" do
    a = [1, 2, 4, 4.5, 5]
    expect(SnowmanIO::Utils.avg(a)).to eq(3.3)
    expect(SnowmanIO::Utils.pct(a, 0.1)).to eq(1)
    expect(SnowmanIO::Utils.pct(a, 0.9)).to eq(5)
  end
end
