# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Base do
  let(:block_class) do
    Class.new(described_class) do
      variants %w[alpha beta gamma], default: "beta"

      def to_html
        %(<div class="#{variant_class('demo')}"></div>)
      end

      def data_to_h
        { variant: @variant }
      end

      private

      def validate
        validate_variant
      end
    end
  end

  describe ".variants" do
    it "declares allowed variants" do
      expect(block_class.variants).to eq(%w[alpha beta gamma])
    end

    it "exposes default variant" do
      expect(block_class.default_variant).to eq("beta")
    end

    it "defaults to first variant when default not specified" do
      other = Class.new(described_class) do
        variants %w[one two three]
      end
      expect(other.default_variant).to eq("one")
    end
  end

  describe "#initialize with variant" do
    it "accepts valid variant" do
      block = block_class.new(id: "1", type: "demo", variant: "gamma")
      expect(block.variant).to eq("gamma")
    end

    it "falls back to default for unknown variant" do
      block = block_class.new(id: "1", type: "demo", variant: "invalid")
      expect(block.variant).to eq("beta")
    end

    it "falls back to default when variant is missing" do
      block = block_class.new(id: "1", type: "demo")
      expect(block.variant).to eq("beta")
    end
  end

  describe "#variant_class" do
    it "appends variant to prefix" do
      block = block_class.new(id: "1", type: "demo", variant: "alpha")
      expect(block.variant_class("demo")).to eq("demo demo--alpha")
    end

    it "returns bare prefix when no variants declared" do
      other_class = Class.new(described_class) do
        def to_html = ""
        def data_to_h = {}
      end
      block = other_class.new(id: "1", type: "x")
      expect(block.variant_class("foo")).to eq("foo")
    end
  end

  describe "#valid? with variant" do
    it "is valid for allowed variant" do
      block = block_class.new(id: "1", type: "demo", variant: "alpha")
      expect(block).to be_valid
    end

    it "is valid when falling back to default" do
      block = block_class.new(id: "1", type: "demo", variant: "bogus")
      expect(block).to be_valid
    end
  end

  describe "blocks without variants" do
    it "does not break existing blocks" do
      block = EditorjsRails::Blocks::Paragraph.new(id: "1", type: "paragraph", text: "hi")
      expect(block.variant).to be_nil
      expect(block.variant_class("editorjs-paragraph")).to eq("editorjs-paragraph")
    end
  end
end
