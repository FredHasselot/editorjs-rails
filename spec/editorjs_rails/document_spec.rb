# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Document do
  let(:json_hash) do
    {
      "time" => 1_234_567_890,
      "version" => "2.31.0",
      "blocks" => [
        { "id" => "a", "type" => "header", "data" => { "text" => "Title", "level" => 2 } },
        { "id" => "b", "type" => "paragraph", "data" => { "text" => "Hello world." } },
        { "id" => "c", "type" => "delimiter", "data" => {} }
      ]
    }
  end

  describe "#initialize" do
    it "parses a hash" do
      doc = described_class.new(json_hash)
      expect(doc.blocks.size).to eq(3)
      expect(doc.version).to eq("2.31.0")
    end

    it "parses a JSON string" do
      doc = described_class.new(JSON.generate(json_hash))
      expect(doc.blocks.size).to eq(3)
    end

    it "accepts symbol keys" do
      sym_hash = {
        time: 123, version: "2.0",
        blocks: [{ id: "1", type: "paragraph", data: { text: "Hi" } }]
      }
      doc = described_class.new(sym_hash)
      expect(doc.blocks.size).to eq(1)
    end
  end

  describe "#to_html" do
    it "renders all blocks" do
      doc = described_class.new(json_hash)
      html = doc.to_html
      expect(html).to include("<h2>Title</h2>")
      expect(html).to include("<p>Hello world.</p>")
      expect(html).to include("<hr>")
    end
  end

  describe "#valid?" do
    it "is valid with valid blocks" do
      doc = described_class.new(json_hash)
      expect(doc).to be_valid
    end

    it "is invalid with empty blocks" do
      doc = described_class.new({ "blocks" => [] })
      expect(doc).not_to be_valid
      expect(doc.errors).to include("blocks cannot be empty")
    end

    it "reports block-level errors" do
      bad_hash = {
        "blocks" => [
          { "id" => "1", "type" => "header", "data" => { "text" => "", "level" => 2 } }
        ]
      }
      doc = described_class.new(bad_hash)
      expect(doc).not_to be_valid
      expect(doc.errors.first).to match(/Block 0/)
    end
  end

  describe "#to_h" do
    it "round-trips the document" do
      doc = described_class.new(json_hash)
      h = doc.to_h
      expect(h[:version]).to eq("2.31.0")
      expect(h[:blocks].size).to eq(3)
      expect(h[:blocks].first[:type]).to eq("header")
    end
  end

  describe "unknown block types" do
    it "silently skips unknown block types" do
      hash = { "blocks" => [{ "id" => "1", "type" => "unknown_widget", "data" => {} }] }
      doc = described_class.new(hash)
      expect(doc.blocks).to be_empty
    end
  end
end
