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
    expect(SnowmanIO.adapter.get("integer@key")).to be_nil
    SnowmanIO.adapter.set("integer@key", 123)
    expect(SnowmanIO.adapter.get("integer@key")).to eq(123)
    SnowmanIO.adapter.set("integer@key", 456)
    expect(SnowmanIO.adapter.get("integer@key")).to eq(456)
  end

  it "supports incr" do
    expect(SnowmanIO.adapter.incr("integer@key")).to eq(1)
    SnowmanIO.adapter.set("integer@key", 5)
    expect(SnowmanIO.adapter.incr("integer@key")).to eq(6)
    expect(SnowmanIO.adapter.get("integer@key")).to eq(6)
  end

  it "supports arrays" do
    SnowmanIO.adapter.push("array@key", 4, "a")
    SnowmanIO.adapter.push("array@key", 4, "b")
    SnowmanIO.adapter.push("array@key", 4, 33.5)
    expect(SnowmanIO.adapter.get("array@key")).to eq(["a", "b", 33.5])
    SnowmanIO.adapter.push("array@key", 4, "d")
    SnowmanIO.adapter.push("array@key", 4, "e")
    expect(SnowmanIO.adapter.get("array@key")).to eq(["b", 33.5, "d", "e"])
  end

  it "supports keys" do
    SnowmanIO.adapter.set("checks@name1@sha1", "bd5")
    SnowmanIO.adapter.set("checks@name2@sha1", "b58")
    SnowmanIO.adapter.set("checks@name3@sha1", "975")
    SnowmanIO.adapter.set("checks@name4@sha", "ignore it")
    SnowmanIO.adapter.set("checks@name4@sha12", "ignore it")

    expect(SnowmanIO.adapter.keys("checks@*@sha1").sort).to eq(%w[
      checks@name1@sha1
      checks@name2@sha1
      checks@name3@sha1
    ])
  end
end
