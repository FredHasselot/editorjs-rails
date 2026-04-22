# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::PullQuote do
  describe ".variants" do
    it "declares the three editorial variants" do
      expect(described_class.variants).to eq(%w[colored-panel oversized-quote minimal-border])
    end

    it "defaults to colored-panel" do
      expect(described_class.default_variant).to eq("colored-panel")
    end
  end

  describe "#to_html" do
    it "wraps the text in a figure + blockquote with base + variant class" do
      block = described_class.new(id: "1", type: "pull_quote", text: "Be kind.")
      html = block.to_html
      expect(html).to start_with('<figure class="editorjs-pull-quote editorjs-pull-quote--colored-panel"')
      expect(html).to include('<blockquote class="editorjs-pull-quote__text">Be kind.</blockquote>')
    end

    it "respects a valid variant" do
      block = described_class.new(id: "1", type: "pull_quote", text: "Q", variant: "oversized-quote")
      expect(block.to_html).to include("editorjs-pull-quote--oversized-quote")
    end

    it "includes the attribution when present" do
      block = described_class.new(id: "1", type: "pull_quote", text: "Q", attribution: "— Author")
      expect(block.to_html).to include('<figcaption class="editorjs-pull-quote__attribution">— Author</figcaption>')
    end

    it "omits the figcaption when attribution is blank" do
      block = described_class.new(id: "1", type: "pull_quote", text: "Q", attribution: "")
      expect(block.to_html).not_to include("<figcaption")
    end

    it "sanitizes inline HTML (keeps em, strips script)" do
      block = described_class.new(id: "1", type: "pull_quote", text: "<em>Q</em><script>x</script>")
      expect(block.to_html).to include("<em>Q</em>")
      expect(block.to_html).not_to include("<script>")
    end
  end

  describe "#valid?" do
    it "is invalid when text is blank" do
      block = described_class.new(id: "1", type: "pull_quote", text: "")
      expect(block).not_to be_valid
    end

    it "is valid without attribution" do
      block = described_class.new(id: "1", type: "pull_quote", text: "Q")
      expect(block).to be_valid
    end
  end
end
