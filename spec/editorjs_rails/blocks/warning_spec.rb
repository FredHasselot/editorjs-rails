# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Warning do
  describe "#to_html" do
    it "renders title and message" do
      block = described_class.new(id: "1", type: "warning", title: "Attention", message: "Be careful")
      html = block.to_html
      expect(html).to include("<strong>Attention</strong>")
      expect(html).to include("<p>Be careful</p>")
      expect(html).to include("editorjs-warning")
    end

    it "omits title when blank" do
      block = described_class.new(id: "1", type: "warning", title: "", message: "Only message")
      expect(block.to_html).not_to include("<strong>")
    end
  end

  describe "#valid?" do
    it "is invalid when both title and message are blank" do
      block = described_class.new(id: "1", type: "warning", title: "", message: "")
      expect(block).not_to be_valid
    end

    it "is valid with only title" do
      block = described_class.new(id: "1", type: "warning", title: "Title", message: "")
      expect(block).to be_valid
    end
  end
end
