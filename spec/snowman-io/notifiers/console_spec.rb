require 'spec_helper'

RSpec.describe SnowmanIO::Notifiers::Console do
  before do
    @prev_tz = ENV['TZ']
    ENV['TZ'] = 'Europe/Moscow'
    Timecop.freeze(Time.new(2014, 12, 25, 10, 47))
  end

  after do
    Timecop.return
    ENV['TZ'] = @prev_tz
  end

  it "notify fail to console" do
    SnowmanIO.store.set_base_url("http://example.com")
    expect(SnowmanIO.logger).to receive(:info).with("
      Notify fired: FailedCheck failed - 2014-12-25 10:47:00 +0300
      ----
      FailedCheck - FAIL
      http://example.com/checks/FailedCheck
    ".strip_heredoc.rstrip)
    check_result = SnowmanIO::CheckResult.new(FailedCheck, "failed", "FailedCheck - FAIL")
    SnowmanIO::Notifiers::Console.new.notify(check_result)
  end
end
