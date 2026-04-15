# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Table do
  describe "#to_html" do
    it "renders a table without headings" do
      block = described_class.new(id: "1", type: "table", content: [%w[A B], %w[C D]])
      html = block.to_html
      expect(html).to include("<tbody>")
      expect(html).to include("<td>A</td>")
      expect(html).not_to include("<thead>")
    end

    it "renders a table with headings" do
      block = described_class.new(id: "1", type: "table", content: [%w[H1 H2], %w[A B]], withHeadings: true)
      html = block.to_html
      expect(html).to include("<thead>")
      expect(html).to include("<th>H1</th>")
      expect(html).to include("<td>A</td>")
    end

    it "returns empty string for empty content" do
      block = described_class.new(id: "1", type: "table", content: [])
      expect(block.to_html).to eq("")
    end
  end

  describe "#valid?" do
    it "is invalid with empty content" do
      block = described_class.new(id: "1", type: "table", content: [])
      expect(block).not_to be_valid
    end
  end
end
