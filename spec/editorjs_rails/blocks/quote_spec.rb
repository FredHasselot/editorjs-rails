# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Quote do
  describe "#to_html" do
    it "renders blockquote with text" do
      block = described_class.new(id: "1", type: "quote", text: "A quote")
      expect(block.to_html).to eq("<blockquote>A quote</blockquote>")
    end

    it "renders caption as cite" do
      block = described_class.new(id: "1", type: "quote", text: "Words", caption: "Author")
      expect(block.to_html).to include("<cite>Author</cite>")
    end

    it "omits cite when caption is blank" do
      block = described_class.new(id: "1", type: "quote", text: "Words", caption: "")
      expect(block.to_html).not_to include("<cite>")
    end
  end

  describe "#valid?" do
    it "is invalid with blank text" do
      block = described_class.new(id: "1", type: "quote", text: "")
      expect(block).not_to be_valid
    end
  end
end
