class SimpleCheck < SnowmanIO::Check
  interval 2.seconds

  def ok?
    [false, true, true, true, true].sample
  end
end
