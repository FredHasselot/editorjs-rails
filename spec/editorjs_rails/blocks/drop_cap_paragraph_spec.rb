# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::DropCapParagraph do
  describe ".variants" do
    it "declares serif-color and sans-plain" do
      expect(described_class.variants).to eq(%w[serif-color sans-plain])
    end

    it "defaults to serif-color" do
      expect(described_class.default_variant).to eq("serif-color")
    end
  end

  describe "#to_html" do
    it "wraps the first letter in a span" do
      block = described_class.new(id: "1", type: "drop_cap_paragraph", text: "Lorem ipsum dolor")
      html = block.to_html
      expect(html).to include(%(<span class="editorjs-drop-cap__letter">L</span>orem ipsum dolor))
    end

    it "includes the base + variant class" do
      block = described_class.new(id: "1", type: "drop_cap_paragraph", text: "Foo", variant: "sans-plain")
      expect(block.to_html).to start_with('<p class="editorjs-drop-cap editorjs-drop-cap--sans-plain"')
    end

    it "falls back to default variant for unknown value" do
      block = described_class.new(id: "1", type: "drop_cap_paragraph", text: "Foo", variant: "rainbow")
      expect(block.to_html).to include("editorjs-drop-cap--serif-color")
    end

    it "preserves inline formatting after the drop cap" do
      block = described_class.new(id: "1", type: "drop_cap_paragraph", text: "Lorem <em>ipsum</em>")
      expect(block.to_html).to include(%(<span class="editorjs-drop-cap__letter">L</span>orem <em>ipsum</em>))
    end

    it "handles text wrapped in an inline tag (picks the first letter inside)" do
      block = described_class.new(id: "1", type: "drop_cap_paragraph", text: "<strong>Amazing</strong> day")
      expect(block.to_html).to include(%(<strong><span class="editorjs-drop-cap__letter">A</span>mazing</strong> day))
    end

    it "strips script tags" do
      block = described_class.new(id: "1", type: "drop_cap_paragraph", text: "Hi<script>alert(1)</script>")
      expect(block.to_html).not_to include("<script>")
    end
  end

  describe "#valid?" do
    it "is invalid when text is blank" do
      block = described_class.new(id: "1", type: "drop_cap_paragraph", text: "")
      expect(block).not_to be_valid
    end
  end
end
