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

  context "Base" do
    it "returns default interval" do
      check = TestCheck.new
      expect(check.class.interval).to eq(60)
    end

    it "sets custom interval for 2 checks independently" do
      expect(Test2Check.interval).to eq(300)
      expect(Test3Check.interval).to eq(3600)
    end

    it "returns default human name" do
      expect(TestCheck.human).to eq("TestCheck")
    end

    it "sets custom human names for 2 checks independently" do
      expect(Test2Check.human).to eq("Test2Check: check2")
      expect(Test3Check.human).to eq("Test3Check: check3")
    end

    it "set configured notifiers" do
      expect(SnowmanIO::Notifiers::Slack).to receive(:configured?).and_return(true)
      expect(SnowmanIO::Notifiers::Mail).to receive(:configured?).and_return(false)
      check = Class.new(SnowmanIO::Check).new
      expect(check.class.notifiers).to eq([SnowmanIO::Notifiers::Console, SnowmanIO::Notifiers::Slack])
    end

    it "performs success check" do
      hr = TestCheck.new.perform
      expect(hr.status).to eq("success")
      expect(hr.message).to eq("TestCheck - OK")
    end

    it "performs failed check" do
      hr = FailedCheck.new.perform
      expect(hr.status).to eq("failed")
      expect(hr.message).to eq("FailedCheck - FAIL")
    end
  end

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
