require 'spec_helper'

RSpec.describe SnowmanIO::CheckResult do
  let(:success) { SnowmanIO::CheckResult.new("TestCheck", "success", "TestCheck - OK") }
  let(:failed) { SnowmanIO::CheckResult.new("TestCheck", "failed", "TestCheck - FAIL") }

  it "serializes self" do
    expect(success.serialize).to eq("{\"status\":\"success\",\"message\":\"TestCheck - OK\"}")
    expect(failed.serialize).to eq("{\"status\":\"failed\",\"message\":\"TestCheck - FAIL\"}")
  end

  it "#fail?" do
    expect(success).not_to be_fail
    expect(failed).to be_fail
  end
end
