require 'spec_helper'

RSpec.describe SnowmanIO::Options do
  before do
    $stdout = StringIO.new
  end

  after do
    $stdout = STDOUT
  end

  it "prints usage end exits" do
    args = ["-h"]
    expect { SnowmanIO::Options.new.parse!(args) }.to raise_error(SystemExit)
    expect($stdout.string).to match(/Usage:/)
  end

  it "sets default port" do
    args = []
    options = SnowmanIO::Options.new.parse!(args)
    expect(options[:port]).to eq(4567)
  end

  it "parses port option" do
    args = ["-p", "1234"]
    options = SnowmanIO::Options.new.parse!(args)
    expect(options[:port]).to eq(1234)
  end

  it "parses verbose option" do
    args = ["-v"]
    options = SnowmanIO::Options.new.parse!(args)
    expect(options[:verbose]).to be_truthy
  end
end
