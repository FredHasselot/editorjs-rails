# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Helper do
  include described_class

  after { EditorjsRails.reset! }

  let(:json_hash) do
    {
      "blocks" => [
        { "id" => "1", "type" => "paragraph", "data" => { "text" => "Hello" } }
      ]
    }
  end

  describe "#render_editorjs" do
    it "renders blocks wrapped in a div" do
      html = render_editorjs(json_hash)
      expect(html).to include('<div class="editorjs-content">')
      expect(html).to include("<p>Hello</p>")
      expect(html).to include("</div>")
    end

    it "accepts a JSON string" do
      html = render_editorjs(JSON.generate(json_hash))
      expect(html).to include("<p>Hello</p>")
    end

    it "accepts a Document instance" do
      doc = EditorjsRails::Document.new(json_hash)
      html = render_editorjs(doc)
      expect(html).to include("<p>Hello</p>")
    end

    it "returns empty string for nil" do
      expect(render_editorjs(nil)).to eq("")
    end

    it "respects custom wrapper_tag" do
      html = render_editorjs(json_hash, wrapper_tag: :article)
      expect(html).to include("<article")
      expect(html).to include("</article>")
    end

    it "respects custom css_class" do
      html = render_editorjs(json_hash, css_class: "my-content")
      expect(html).to include('class="my-content"')
    end

    it "uses configuration css_class_prefix" do
      EditorjsRails.configure { |c| c.css_class_prefix = "pave" }
      html = render_editorjs(json_hash)
      expect(html).to include('class="pave-content"')
    end

    it "uses configuration wrapper_tag" do
      EditorjsRails.configure { |c| c.wrapper_tag = :section }
      html = render_editorjs(json_hash)
      expect(html).to include("<section")
    end

    it "returns html_safe string" do
      html = render_editorjs(json_hash)
      expect(html).to be_html_safe
    end
  end
end
