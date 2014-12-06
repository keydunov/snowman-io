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
    context "with HG_KEY" do
      before do
        @old_hg_key = ENV["HG_KEY"]
        ENV["HG_KEY"] = "/hg/key"
      end

      after do
        ENV["HG_KEY"] = @old_hg_key
      end

      it "returns last value" do
        url = "https://www.hostedgraphite.com/hg/key/graphite/render?format=json&target=#{hg_target}&from=-10mins"
        expect(check).to receive(:open).with(url) { StringIO.new(JSON.dump(hg_response)) }

        expect(check.send(:get_hg_value, hg_target)).to eq(9)
      end

      it "returns nil if empty dataset" do
        url = "https://www.hostedgraphite.com/hg/key/graphite/render?format=json&target=#{hg_target}&from=-10mins"
        expect(check).to receive(:open).with(url) { StringIO.new(JSON.dump(hg_empty_response)) }

        expect(check.send(:get_hg_value, hg_target)).to be_nil
      end

      it "gets data for last 20 minutes" do
        url = "https://www.hostedgraphite.com/hg/key/graphite/render?format=json&target=#{hg_target}&from=-20mins"
        expect(check).to receive(:open).with(url) { StringIO.new(JSON.dump(hg_response)) }

        expect(check.send(:get_hg_value, hg_target, from: '-20mins')).to eq(9)
      end
    end

    context "without HG_KEY" do
      it "returns nil" do
        expect(check.send(:get_hg_value, hg_target)).to be_nil
      end
    end
  end
end
