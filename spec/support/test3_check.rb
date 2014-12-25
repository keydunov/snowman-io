class Test3Check < SnowmanIO::Check
  interval 1.hour
  human "check3"

  def ok?
    true
  end
end
