class Simple2Check < SnowmanIO::Check
  interval 5.seconds

  def ok?
    true
  end
end
