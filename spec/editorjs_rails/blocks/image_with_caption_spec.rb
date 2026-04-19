# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::ImageWithCaption do
  let(:image) { { url: "https://cdn.test/a.jpg", alt: "A" } }

  describe ".variants" do
    it "declares the three variants" do
      expect(described_class.variants).to eq(%w[below-small-caps side overlay])
    end

    it "defaults to below-small-caps" do
      expect(described_class.default_variant).to eq("below-small-caps")
    end
  end

  describe "#to_html" do
    it "renders figure with img and base + variant class" do
      block = described_class.new(id: "1", type: "image_with_caption", image: image, caption: "Hello")
      html = block.to_html
      expect(html).to start_with('<figure class="editorjs-image-caption editorjs-image-caption--below-small-caps"')
      expect(html).to include('<img src="https://cdn.test/a.jpg" alt="A">')
    end

    it "includes caption span when caption is present" do
      block = described_class.new(id: "1", type: "image_with_caption", image: image, caption: "Hi")
      expect(block.to_html).to include('<span class="editorjs-image-caption__caption">Hi</span>')
    end

    it "includes credit span when credit is present" do
      block = described_class.new(id: "1", type: "image_with_caption", image: image, credit: "© Me")
      expect(block.to_html).to include('<span class="editorjs-image-caption__credit">© Me</span>')
    end

    it "omits figcaption when both caption and credit are blank" do
      block = described_class.new(id: "1", type: "image_with_caption", image: image)
      expect(block.to_html).not_to include("<figcaption")
    end

    it "escapes a dangerous url" do
      block = described_class.new(id: "1", type: "image_with_caption", image: { url: %("><script>x</script>) })
      expect(block.to_html).not_to include("<script>")
    end

    it "respects a valid variant" do
      block = described_class.new(id: "1", type: "image_with_caption", image: image, variant: "overlay")
      expect(block.to_html).to include("editorjs-image-caption--overlay")
    end
  end

  describe "#valid?" do
    it "is invalid with blank image url" do
      block = described_class.new(id: "1", type: "image_with_caption", image: { url: "" })
      expect(block).not_to be_valid
    end

    it "is valid with only an image (no caption/credit)" do
      block = described_class.new(id: "1", type: "image_with_caption", image: image)
      expect(block).to be_valid
    end
  end
end
