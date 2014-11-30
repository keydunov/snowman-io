require 'snowman-io'

RSpec.describe SnowmanIO::Options do
  before do
    $stdout = StringIO.new
  end

  after do
    $stdout = STDOUT
  end

  it "prints usage end exits for empty args" do
    args = []
    expect { SnowmanIO::Options.new.parse!(args) }.to raise_error(SystemExit)
    expect($stdout.string).to match(/Usage:/)
  end

  it "prints error message, usage and exits in case of unknown command" do
    args = ["unknown_command"]
    expect { SnowmanIO::Options.new.parse!(args) }.to raise_error(SystemExit)
    expect($stdout.string).to match(/Error: Command.*not recognized/)
    expect($stdout.string).to match(/Usage:/)
  end

  context "server" do
    it "sets default port" do
      args = ["server"]
      options = SnowmanIO::Options.new.parse!(args)
      expect(options).to eq(command: "server", port: 4567)
    end

    it "parses port option" do
      args = ["server", "-p", "1234"]
      options = SnowmanIO::Options.new.parse!(args)
      expect(options).to eq(command: "server", port: 1234)
    end
  end
end
