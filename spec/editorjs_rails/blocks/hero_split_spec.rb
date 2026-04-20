# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::HeroSplit do
  let(:image) { { url: "https://cdn.test/a.jpg", alt: "Alt", credit: "© Me" } }

  describe ".variants" do
    it "declares the three editorial variants" do
      expect(described_class.variants).to eq(%w[title-above title-right title-overlap])
    end

    it "defaults to title-above" do
      expect(described_class.default_variant).to eq("title-above")
    end
  end

  describe "#to_html" do
    it "renders the section with base class + variant class" do
      block = described_class.new(id: "1", type: "hero_split", title: "Hello", image: image)
      html = block.to_html
      expect(html).to start_with('<section class="editorjs-hero-split editorjs-hero-split--title-above"')
      expect(html).to include('data-editorial-block="hero_split"')
    end

    it "falls back to default variant when unknown variant is given" do
      block = described_class.new(id: "1", type: "hero_split", variant: "bogus", title: "Hi", image: image)
      expect(block.to_html).to include("editorjs-hero-split--title-above")
    end

    it "respects a valid variant" do
      block = described_class.new(id: "1", type: "hero_split", variant: "title-overlap", title: "Hi", image: image)
      expect(block.to_html).to include("editorjs-hero-split--title-overlap")
    end

    it "renders the title with the requested tag" do
      block = described_class.new(id: "1", type: "hero_split", title: "Foo", title_tag: "h2", image: image)
      expect(block.to_html).to include("<h2 class=\"editorjs-hero-split__title\">Foo</h2>")
    end

    it "falls back to h1 for an unknown title_tag" do
      block = described_class.new(id: "1", type: "hero_split", title: "Foo", title_tag: "script", image: image)
      expect(block.to_html).to include("<h1 class=\"editorjs-hero-split__title\">Foo</h1>")
    end

    it "renders the image inside a figure" do
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: image)
      expect(block.to_html).to include(%(<img src="https://cdn.test/a.jpg" alt="Alt">))
    end

    it "includes the credit inside a figcaption when present" do
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: image)
      expect(block.to_html).to include(%(<figcaption class="editorjs-hero-split__credit">© Me</figcaption>))
    end

    it "includes the caption inside its own figcaption when present" do
      img = image.merge(caption: "A caption")
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: img)
      expect(block.to_html).to include(%(<figcaption class="editorjs-hero-split__caption">A caption</figcaption>))
    end

    it "renders caption before credit" do
      img = image.merge(caption: "Caption text")
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: img)
      caption_pos = block.to_html.index("editorjs-hero-split__caption")
      credit_pos = block.to_html.index("editorjs-hero-split__credit")
      expect(caption_pos).to be < credit_pos
    end

    it "omits the figcaption when credit and caption are blank" do
      img = image.merge(credit: "", caption: "")
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: img)
      expect(block.to_html).not_to include("<figcaption")
    end

    it "escapes a dangerous image url" do
      img = { url: %(https://x/"><script>alert(1)</script>), alt: "a", credit: "" }
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: img)
      expect(block.to_html).not_to include("<script>")
    end

    it "sanitizes inline HTML inside the title (strips script, keeps em)" do
      block = described_class.new(id: "1", type: "hero_split", title: "<em>Hi</em><script>x</script>", image: image)
      expect(block.to_html).to include("<em>Hi</em>")
      expect(block.to_html).not_to include("<script>")
    end
  end

  describe "#valid?" do
    it "is invalid with blank title" do
      block = described_class.new(id: "1", type: "hero_split", title: "", image: image)
      expect(block).not_to be_valid
      expect(block.errors).to include("title cannot be blank")
    end

    it "is invalid with blank image url" do
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: { url: "" })
      expect(block).not_to be_valid
      expect(block.errors).to include("image url cannot be blank")
    end

    it "is valid with title + image" do
      block = described_class.new(id: "1", type: "hero_split", title: "T", image: image)
      expect(block).to be_valid
    end
  end

  describe "#to_h" do
    it "round-trips through the block registry" do
      EditorjsRails::BlockRegistry.register("hero_split", described_class)
      original = described_class.new(id: "abc", type: "hero_split", variant: "title-right", title: "Title", image: image)
      rebuilt = EditorjsRails::BlockRegistry.build("hero_split", "abc", original.to_h[:data])
      expect(rebuilt.to_h[:data][:variant]).to eq("title-right")
      expect(rebuilt.to_h[:data][:title]).to eq("Title")
      expect(rebuilt.to_h[:data][:image][:url]).to eq(image[:url])
    ensure
      EditorjsRails::BlockRegistry.reset!
    end
  end
end
