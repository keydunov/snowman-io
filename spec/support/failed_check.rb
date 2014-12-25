class FailedCheck < SnowmanIO::Check
  def ok?
    false
  end
end
