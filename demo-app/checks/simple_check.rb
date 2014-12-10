class SimpleCheck < SnowmanIO::Check
  interval 3.seconds

  def ok?
    true
  end
end
