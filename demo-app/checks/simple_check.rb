class SimpleCheck < SnowmanIO::Check
  interval 3.seconds

  def ok?
    [false, true].sample
  end
end
