# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Image do
  describe "#to_html" do
    it "renders figure with img" do
      block = described_class.new(id: "1", type: "image", url: "https://example.com/img.jpg")
      html = block.to_html
      expect(html).to include("<figure>")
      expect(html).to include('<img src="https://example.com/img.jpg"')
    end

    it "renders figcaption when caption present" do
      block = described_class.new(id: "1", type: "image", url: "https://example.com/img.jpg", caption: "A photo")
      expect(block.to_html).to include("<figcaption>A photo</figcaption>")
    end

    it "adds CSS classes for options" do
      block = described_class.new(id: "1", type: "image", url: "https://example.com/img.jpg", withBorder: true, stretched: true)
      html = block.to_html
      expect(html).to include("editorjs-image--bordered")
      expect(html).to include("editorjs-image--stretched")
    end

    it "reads url from file hash" do
      block = described_class.new(id: "1", type: "image", file: { "url" => "https://example.com/f.jpg" })
      expect(block.to_html).to include("https://example.com/f.jpg")
    end

    it "returns empty string when url is blank" do
      block = described_class.new(id: "1", type: "image")
      expect(block.to_html).to eq("")
    end
  end

  describe "#valid?" do
    it "is invalid without url" do
      block = described_class.new(id: "1", type: "image")
      expect(block).not_to be_valid
    end
  end
end
