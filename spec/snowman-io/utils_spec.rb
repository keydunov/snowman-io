require 'spec_helper'

RSpec.describe SnowmanIO::Utils, type: :feature do
  it "avg" do
    a = [1, 2, 4, 4.5, 5]
    expect(SnowmanIO::Utils.avg(a)).to eq(3.3)
  end

  it "up" do
    expect(SnowmanIO::Utils.up([1])).to eq(1)
    expect(SnowmanIO::Utils.up([1, 5]).round(2)).to eq(4.43)
    expect(SnowmanIO::Utils.up([1, 5, 1]).round(2)).to eq(3.36)
    expect(SnowmanIO::Utils.up([1, 5, 5]).round(2)).to eq(4.69)
    expect(SnowmanIO::Utils.up([1, 1, 1, 1, 1, 5]).round(2)).to eq(2.2)
  end
end
