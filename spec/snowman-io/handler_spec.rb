require 'spec_helper'

RSpec.describe SnowmanIO::Handler do
  let(:handler) { SnowmanIO::Handler.new }
  let(:fake_check) { Struct.new(:name).new("check") }
  let(:ok) { SnowmanIO::CheckResult.new(fake_check, "success", "check - OK") }
  let(:failed) { SnowmanIO::CheckResult.new(fake_check, "failed", "check - FAIL") }
  let(:exception) { SnowmanIO::CheckResult.new(fake_check, "exception", "check - EXCEPTION") }

  it "doesn't notify if ok" do
    expect(handler.wrapped_object).to_not receive(:notify_fail)
    handler.handle(ok)
  end

  it "notify if failed" do
    expect(handler.wrapped_object).to receive(:notify_fail)
    handler.handle(failed)
  end

  it "notify if exception" do
    expect(handler.wrapped_object).to receive(:notify_fail)
    handler.handle(exception)
  end

  it "notify only once" do
    expect(handler.wrapped_object).to receive(:notify_fail).once
    handler.handle(failed)
    handler.handle(ok)
    handler.handle(failed)
    handler.handle(exception)
  end
end
