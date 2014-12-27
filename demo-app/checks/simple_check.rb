class SimpleCheck < SnowmanIO::Check
  interval 2.seconds

  def ok?
    @some = (1..100).to_a.sample
    @string = "this is check"
    [false, true, true, true, true].sample
  end
end
