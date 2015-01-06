require 'spec_helper'

RSpec.describe SnowmanIO::Adapter do
  it "supports string setters and getters" do
    expect(SnowmanIO.mongo.get("some@key")).to be_nil
    SnowmanIO.mongo.set("some@key", "string")
    expect(SnowmanIO.mongo.get("some@key")).to eq("string")
    SnowmanIO.mongo.set("some@key", "another_string")
    expect(SnowmanIO.mongo.get("some@key")).to eq("another_string")
  end

  it "supports integer setters and getters" do
    expect(SnowmanIO.mongo.get("integer@key")).to be_nil
    SnowmanIO.mongo.set("integer@key", 123)
    expect(SnowmanIO.mongo.get("integer@key")).to eq(123)
    SnowmanIO.mongo.set("integer@key", 456)
    expect(SnowmanIO.mongo.get("integer@key")).to eq(456)
  end

  it "supports json-compatible setters and getters" do
    expect(SnowmanIO.mongo.get("some@key")).to be_nil
    SnowmanIO.mongo.set("some@key", {"id" => 1, "name" => "test"})
    expect(SnowmanIO.mongo.get("some@key")).to eq({"id" => 1, "name" => "test"})
    SnowmanIO.mongo.set("some@key", {"id" => 1, "name" => "other"})
    expect(SnowmanIO.mongo.get("some@key")).to eq({"id" => 1, "name" => "other"})

    expect(SnowmanIO.mongo.keys("some@key")).to eq(["some@key"])
    SnowmanIO.mongo.unset("some@key")
    expect(SnowmanIO.mongo.get("some@key")).to be_nil
    expect(SnowmanIO.mongo.keys("some@key")).to eq([])
  end

  it "supports incr" do
    expect(SnowmanIO.mongo.incr("integer@key")).to eq(1)
    SnowmanIO.mongo.set("integer@key", 5)
    expect(SnowmanIO.mongo.incr("integer@key")).to eq(6)
    expect(SnowmanIO.mongo.get("integer@key")).to eq(6)
  end

  it "supports arrays" do
    SnowmanIO.mongo.push("array@key", 4, "a")
    SnowmanIO.mongo.push("array@key", 4, "b")
    SnowmanIO.mongo.push("array@key", 4, 33.5)
    expect(SnowmanIO.mongo.get("array@key")).to eq(["a", "b", 33.5])
    SnowmanIO.mongo.push("array@key", 4, "d")
    SnowmanIO.mongo.push("array@key", 4, "e")
    expect(SnowmanIO.mongo.get("array@key")).to eq(["b", 33.5, "d", "e"])
  end

  it "supports keys" do
    SnowmanIO.mongo.set("checks@name1@sha1", "bd5")
    SnowmanIO.mongo.set("checks@name2@sha1", "b58")
    SnowmanIO.mongo.set("checks@name3@sha1", "975")
    SnowmanIO.mongo.set("checks@name4@sha", "ignore it")
    SnowmanIO.mongo.set("checks@name4@sha12", "ignore it")

    expect(SnowmanIO.mongo.keys("checks@*@sha1").sort).to eq(%w[
      checks@name1@sha1
      checks@name2@sha1
      checks@name3@sha1
    ])
  end
end
