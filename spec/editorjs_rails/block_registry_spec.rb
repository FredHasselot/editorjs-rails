# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::BlockRegistry do
  after { described_class.reset! }

  describe ".registered?" do
    it "knows default block types" do
      %w[paragraph header list quote delimiter code table image warning checklist].each do |type|
        expect(described_class.registered?(type)).to be true
      end
    end

    it "returns false for unknown types" do
      expect(described_class.registered?("unknown")).to be false
    end
  end

  describe ".register" do
    it "registers a custom block type" do
      custom_class = Class.new(EditorjsRails::Blocks::Base) do
        def to_html
          "<div>custom</div>"
        end

        private

        def data_to_h
          {}
        end
      end

      described_class.register("custom", custom_class)
      expect(described_class.registered?("custom")).to be true
    end
  end

  describe ".build" do
    it "builds the correct block type" do
      block = described_class.build("paragraph", "1", { "text" => "Hello" })
      expect(block).to be_a(EditorjsRails::Blocks::Paragraph)
      expect(block.to_html).to eq("<p>Hello</p>")
    end

    it "returns nil for unknown types" do
      block = described_class.build("unknown", "1", {})
      expect(block).to be_nil
    end
  end

  describe ".reset!" do
    it "restores default blocks after clearing" do
      described_class.register("custom", Class.new)
      described_class.reset!
      expect(described_class.registered?("custom")).to be false
      expect(described_class.registered?("paragraph")).to be true
    end
  end
end
