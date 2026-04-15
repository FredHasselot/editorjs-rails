# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Paragraph do
  subject { described_class.new(id: "1", type: "paragraph", text: text) }

  let(:text) { "Hello world" }

  describe "#to_html" do
    it "renders a <p> tag" do
      expect(subject.to_html).to eq("<p>Hello world</p>")
    end

    it "escapes HTML in text" do
      block = described_class.new(id: "1", type: "paragraph", text: "<script>alert('xss')</script>")
      expect(block.to_html).not_to include("<script>")
      expect(block.to_html).to include("&lt;script&gt;")
    end
  end

  describe "#valid?" do
    it "is valid with text" do
      expect(subject).to be_valid
    end

    it "is invalid with blank text" do
      block = described_class.new(id: "1", type: "paragraph", text: "  ")
      expect(block).not_to be_valid
      expect(block.errors).to include("text cannot be blank")
    end
  end

  describe "#to_h" do
    it "serializes to hash" do
      expect(subject.to_h).to eq({ id: "1", type: "paragraph", data: { text: "Hello world" } })
    end
  end
end
