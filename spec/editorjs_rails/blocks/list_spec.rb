# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::List do
  describe "#to_html" do
    it "renders unordered list" do
      block = described_class.new(id: "1", type: "list", style: "unordered", items: %w[A B])
      expect(block.to_html).to eq("<ul><li>A</li><li>B</li></ul>")
    end

    it "renders ordered list" do
      block = described_class.new(id: "1", type: "list", style: "ordered", items: %w[A B])
      expect(block.to_html).to eq("<ol><li>A</li><li>B</li></ol>")
    end

    it "renders nested items" do
      items = [
        { "content" => "Parent", "items" => [{ "content" => "Child", "items" => [] }] }
      ]
      block = described_class.new(id: "1", type: "list", style: "unordered", items: items)
      html = block.to_html
      expect(html).to include("<li>Parent<ul><li>Child</li></ul></li>")
    end

    it "escapes HTML in items" do
      block = described_class.new(id: "1", type: "list", items: ["<script>x</script>"])
      expect(block.to_html).not_to include("<script>")
    end

    it "renders checklist with checked and unchecked items" do
      items = [
        { "content" => "Done", "meta" => { "checked" => true }, "items" => [] },
        { "content" => "Todo", "meta" => { "checked" => false }, "items" => [] }
      ]
      block = described_class.new(id: "1", type: "list", style: "checklist", items: items)
      html = block.to_html
      expect(html).to include("editorjs-checklist")
      expect(html).to include("checked")
      expect(html).to include("Todo")
      expect(html).to include("disabled")
    end

    it "renders checklist items in labels" do
      items = [{ "content" => "Item", "meta" => { "checked" => false }, "items" => [] }]
      block = described_class.new(id: "1", type: "list", style: "checklist", items: items)
      expect(block.to_html).to include("<label>")
    end
  end

  describe "#valid?" do
    it "is invalid with empty items" do
      block = described_class.new(id: "1", type: "list", items: [])
      expect(block).not_to be_valid
    end

    it "is invalid with bad style" do
      block = described_class.new(id: "1", type: "list", style: "bad", items: ["A"])
      expect(block).not_to be_valid
    end

    it "is valid with checklist style" do
      items = [{ "content" => "Item", "meta" => { "checked" => false }, "items" => [] }]
      block = described_class.new(id: "1", type: "list", style: "checklist", items: items)
      expect(block).to be_valid
    end
  end
end
