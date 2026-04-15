# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::FormBuilder do
  # Minimal form builder stub for testing
  let(:builder_class) do
    Class.new do
      include EditorjsRails::FormBuilder

      attr_reader :object_name, :object

      def initialize(object_name, object)
        @object_name = object_name
        @object = object
      end
    end
  end

  let(:article) { Struct.new(:body).new(nil) }
  let(:builder) { builder_class.new("article", article) }

  after { EditorjsRails.reset! }

  describe "#editorjs" do
    it "renders a wrapper div with data-controller" do
      html = builder.editorjs(:body)
      expect(html).to include('data-controller="editorjs"')
    end

    it "renders an editor target div" do
      html = builder.editorjs(:body)
      expect(html).to include('data-editorjs-target="editor"')
      expect(html).to include('id="article_body_editor"')
    end

    it "renders a hidden input with correct name" do
      html = builder.editorjs(:body)
      expect(html).to include('name="article[body]"')
      expect(html).to include('type="hidden"')
      expect(html).to include('data-editorjs-target="input"')
    end

    it "includes editorjs-field class" do
      html = builder.editorjs(:body)
      expect(html).to include("editorjs-field")
    end

    it "adds dark class when dark: true" do
      html = builder.editorjs(:body, dark: true)
      expect(html).to include("editorjs-dark")
    end

    it "does not add dark class by default" do
      html = builder.editorjs(:body)
      expect(html).not_to include("editorjs-dark")
    end

    it "sets placeholder value" do
      html = builder.editorjs(:body, placeholder: "Write here...")
      expect(html).to include("Write here...")
    end

    it "serializes existing content from object" do
      article_with_body = Struct.new(:body).new({ "blocks" => [{ "type" => "paragraph" }] })
      b = builder_class.new("article", article_with_body)
      html = b.editorjs(:body)
      expect(html).to include("paragraph")
    end

    it "handles string content" do
      json = '{"blocks":[]}'
      article_with_string = Struct.new(:body).new(json)
      b = builder_class.new("article", article_with_string)
      html = b.editorjs(:body)
      expect(html).to include("blocks")
    end

    it "adds custom css_class" do
      html = builder.editorjs(:body, css_class: "my-editor")
      expect(html).to include("my-editor")
    end

    it "returns html_safe string" do
      html = builder.editorjs(:body)
      expect(html).to be_html_safe
    end
  end
end
