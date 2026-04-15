# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Blocks::Delimiter do
  subject { described_class.new(id: "1", type: "delimiter") }

  describe "#to_html" do
    it "renders <hr>" do
      expect(subject.to_html).to eq("<hr>")
    end
  end

  describe "#valid?" do
    it "is always valid" do
      expect(subject).to be_valid
    end
  end

  describe "#to_h" do
    it "serializes with empty data" do
      expect(subject.to_h).to eq({ id: "1", type: "delimiter", data: {} })
    end
  end
end
