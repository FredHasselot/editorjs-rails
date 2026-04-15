# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Checklist do
  describe "#to_html" do
    it "renders checklist with checked and unchecked items" do
      items = [
        { "text" => "Done", "checked" => true },
        { "text" => "Todo", "checked" => false }
      ]
      block = described_class.new(id: "1", type: "checklist", items: items)
      html = block.to_html
      expect(html).to include("editorjs-checklist")
      expect(html).to include("checked")
      expect(html).to include("Todo")
    end

    it "renders items as disabled checkboxes" do
      items = [{ "text" => "Item", "checked" => false }]
      block = described_class.new(id: "1", type: "checklist", items: items)
      expect(block.to_html).to include("disabled")
    end

    it "escapes HTML in text" do
      items = [{ "text" => "<script>x</script>", "checked" => false }]
      block = described_class.new(id: "1", type: "checklist", items: items)
      expect(block.to_html).not_to include("<script>")
    end
  end

  describe "#valid?" do
    it "is invalid with empty items" do
      block = described_class.new(id: "1", type: "checklist", items: [])
      expect(block).not_to be_valid
    end
  end
end
