# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Header do
  subject { described_class.new(id: "1", type: "header", text: "Title", level: 2) }

  describe "#to_html" do
    it "renders the correct heading level" do
      expect(subject.to_html).to eq("<h2>Title</h2>")
    end

    (1..6).each do |level|
      it "renders h#{level}" do
        block = described_class.new(id: "1", type: "header", text: "T", level: level)
        expect(block.to_html).to eq("<h#{level}>T</h#{level}>")
      end
    end

    it "escapes HTML" do
      block = described_class.new(id: "1", type: "header", text: "<b>bold</b>", level: 1)
      expect(block.to_html).to include("&lt;b&gt;")
    end
  end

  describe "#valid?" do
    it "is valid with text and valid level" do
      expect(subject).to be_valid
    end

    it "is invalid with blank text" do
      block = described_class.new(id: "1", type: "header", text: "", level: 2)
      expect(block).not_to be_valid
    end

    it "is invalid with level out of range" do
      block = described_class.new(id: "1", type: "header", text: "T", level: 7)
      expect(block).not_to be_valid
      expect(block.errors).to include("level must be between 1 and 6")
    end
  end
end
