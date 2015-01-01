require 'spec_helper'

RSpec.describe SnowmanIO::Adapter do
  it "supports string setters and getters" do
    expect(SnowmanIO.adapter.get("some@key")).to be_nil
    SnowmanIO.adapter.set("some@key", "string")
    expect(SnowmanIO.adapter.get("some@key")).to eq("string")
    SnowmanIO.adapter.set("some@key", "another_string")
    expect(SnowmanIO.adapter.get("some@key")).to eq("another_string")
  end

  it "supports integer setters and getters" do
    expect(SnowmanIO.adapter.geti("integer@key")).to be_nil
    SnowmanIO.adapter.seti("integer@key", 123)
    expect(SnowmanIO.adapter.geti("integer@key")).to eq(123)
    SnowmanIO.adapter.seti("integer@key", 456)
    expect(SnowmanIO.adapter.geti("integer@key")).to eq(456)
  end

  it "supports incr" do
    expect(SnowmanIO.adapter.incr("integer@key")).to eq(1)
    SnowmanIO.adapter.seti("integer@key", 5)
    expect(SnowmanIO.adapter.incr("integer@key")).to eq(6)
    expect(SnowmanIO.adapter.geti("integer@key")).to eq(6)
  end

  it "supports arrays" do
    expect(SnowmanIO.adapter.geta("array@key")).to eq([])

    SnowmanIO.adapter.push("array@key", "a")
    SnowmanIO.adapter.push("array@key", "b")
    SnowmanIO.adapter.push("array@key", "c")
    expect(SnowmanIO.adapter.geta("array@key")).to eq(["a", "b", "c"])
    expect(SnowmanIO.adapter.len("array@key")).to eq(3)

    expect(SnowmanIO.adapter.shift("array@key")).to eq("a")
    expect(SnowmanIO.adapter.geta("array@key")).to eq(["b", "c"])
    expect(SnowmanIO.adapter.len("array@key")).to eq(2)

    expect(SnowmanIO.adapter.shift("array@key")).to eq("b")
    expect(SnowmanIO.adapter.shift("array@key")).to eq("c")
    expect(SnowmanIO.adapter.geta("array@key")).to eq([])
    expect(SnowmanIO.adapter.len("array@key")).to eq(0)

    expect(SnowmanIO.adapter.shift("array@key")).to be_nil
  end

  it "supports keys" do
    SnowmanIO.adapter.set("checks@name1@sha1", "bd5")
    SnowmanIO.adapter.set("checks@name2@sha1", "b58")
    SnowmanIO.adapter.set("checks@name3@sha1", "975")
    SnowmanIO.adapter.set("checks@name4@sha", "ignore it")

    expect(SnowmanIO.adapter.keys("checks@*@sha1").sort).to eq(%w[
      checks@name1@sha1
      checks@name2@sha1
      checks@name3@sha1
    ])
  end
end
