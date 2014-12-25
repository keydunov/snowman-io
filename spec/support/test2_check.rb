class Test2Check < SnowmanIO::Check
  interval 5.minutes
  human "check2"

  def ok?
    true
  end
end
