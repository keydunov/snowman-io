class Simple2Check < SnowmanIO::Check
  interval 20.seconds

  def ok?
    [false, true].sample
  end
end
