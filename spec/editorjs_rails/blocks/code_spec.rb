# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Code do
  describe "#to_html" do
    it "renders pre > code" do
      block = described_class.new(id: "1", type: "code", code: "puts 'hello'")
      expect(block.to_html).to eq("<pre><code>puts &#39;hello&#39;</code></pre>")
    end

    it "escapes HTML in code" do
      block = described_class.new(id: "1", type: "code", code: "<div>html</div>")
      expect(block.to_html).to include("&lt;div&gt;")
    end
  end

  describe "#valid?" do
    it "is invalid with blank code" do
      block = described_class.new(id: "1", type: "code", code: "")
      expect(block).not_to be_valid
    end
  end
end
