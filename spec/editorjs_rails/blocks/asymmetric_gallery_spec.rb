# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::AsymmetricGallery do
  let(:img1) { { url: "https://cdn.test/1.jpg", alt: "1", caption: "" } }
  let(:img2) { { url: "https://cdn.test/2.jpg", alt: "2", caption: "" } }
  let(:img3) { { url: "https://cdn.test/3.jpg", alt: "3", caption: "" } }
  let(:img4) { { url: "https://cdn.test/4.jpg", alt: "4", caption: "" } }

  describe ".variants" do
    it "declares the three variants" do
      expect(described_class.variants).to eq(%w[triptyque duo-offset collage-rotated])
    end

    it "defaults to triptyque" do
      expect(described_class.default_variant).to eq("triptyque")
    end
  end

  describe "#to_html" do
    it "renders a wrapper with figure per image" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [img1, img2, img3])
      html = block.to_html
      expect(html).to start_with('<div class="editorjs-gallery editorjs-gallery--triptyque"')
      expect(html.scan(/<figure/).size).to eq(3)
    end

    it "indexes each figure" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [img1, img2])
      expect(block.to_html).to include("editorjs-gallery__item--0")
      expect(block.to_html).to include("editorjs-gallery__item--1")
    end

    it "renders an empty string for empty images list" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [])
      expect(block.to_html).to eq("")
    end

    it "includes caption figcaption when present" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [img1.merge(caption: "Hi")])
      expect(block.to_html).to include('<figcaption class="editorjs-gallery__caption">Hi</figcaption>')
    end

    it "escapes dangerous urls" do
      bad = { url: %("><script>x</script>), alt: "", caption: "" }
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [bad, img1, img2])
      expect(block.to_html).not_to include("<script>")
    end
  end

  describe "#valid?" do
    it "is valid with 3 images for triptyque" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [img1, img2, img3])
      expect(block).to be_valid
    end

    it "is invalid with 2 images for triptyque" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [img1, img2])
      expect(block).not_to be_valid
      expect(block.errors.first).to match(/triptyque requires 3-3/)
    end

    it "is valid with 2 images for duo-offset" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", variant: "duo-offset", images: [img1, img2])
      expect(block).to be_valid
    end

    it "is valid with 3 or 4 images for collage-rotated" do
      three = described_class.new(id: "1", type: "asymmetric_gallery", variant: "collage-rotated", images: [img1, img2, img3])
      four  = described_class.new(id: "1", type: "asymmetric_gallery", variant: "collage-rotated", images: [img1, img2, img3, img4])
      expect(three).to be_valid
      expect(four).to be_valid
    end

    it "rejects an image with blank url" do
      block = described_class.new(id: "1", type: "asymmetric_gallery", images: [img1, img2, { url: "", alt: "x" }])
      expect(block).not_to be_valid
      expect(block.errors.any? { |e| e.include?("url cannot be blank") }).to be true
    end
  end
end
