require 'spec_helper'

RSpec.describe SnowmanIO::Check do
  let(:check) { SnowmanIO::Check.new }
  let(:hg_target) { "integral(*.people:sum)" }
  let(:hg_response) {
    [{
      "target" => hg_target,
      "datapoints" => [
        [nil, 1417632341],
        [5,1417632346],
        [9, 1417632351],
        [nil, 1417632356]
      ]
    }]
  }
  let(:hg_empty_response) {
    [{
      "target" => hg_target,
      "datapoints" => []
    }]
  }

  context "Hosted Graphite" do
    it "returns last value" do
      expect(ENV).to receive(:[]).with("HG_KEY").and_return("/hg/key")
      url = "https://www.hostedgraphite.com/hg/key/graphite/render?format=json&target=#{hg_target}&from=-10mins"
      expect(check).to receive(:open).with(url) { StringIO.new(JSON.dump(hg_response)) }

      expect(check.send(:get_hg_value, hg_target)).to eq(9)
    end

    it "returns nil if empty dataset" do
      expect(ENV).to receive(:[]).with("HG_KEY").and_return("/hg/key")
      url = "https://www.hostedgraphite.com/hg/key/graphite/render?format=json&target=#{hg_target}&from=-10mins"
      expect(check).to receive(:open).with(url) { StringIO.new(JSON.dump(hg_empty_response)) }

      expect(check.send(:get_hg_value, hg_target)).to be_nil
    end

    it "returns nil unless HG_KEY env variable is setted" do
      expect(ENV).to receive(:[]).with("HG_KEY").and_return(nil)
      expect(check.send(:get_hg_value, hg_target)).to be_nil
    end

    it "gets data for last 20 minutes" do
      expect(ENV).to receive(:[]).with("HG_KEY").and_return("/hg/key")
      url = "https://www.hostedgraphite.com/hg/key/graphite/render?format=json&target=#{hg_target}&from=-20mins"
      expect(check).to receive(:open).with(url) { StringIO.new(JSON.dump(hg_response)) }

      expect(check.send(:get_hg_value, hg_target, from: '-20mins')).to eq(9)
    end
  end
end
