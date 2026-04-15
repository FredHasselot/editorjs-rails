# frozen_string_literal: true

require "spec_helper"

RSpec.describe EditorjsRails::Configuration do
  after { EditorjsRails.reset! }

  describe "defaults" do
    it "has sanitize enabled" do
      expect(EditorjsRails.configuration.sanitize).to be true
    end

    it "has editorjs as css_class_prefix" do
      expect(EditorjsRails.configuration.css_class_prefix).to eq("editorjs")
    end

    it "has :div as wrapper_tag" do
      expect(EditorjsRails.configuration.wrapper_tag).to eq(:div)
    end
  end

  describe "EditorjsRails.configure" do
    it "allows setting sanitize" do
      EditorjsRails.configure { |c| c.sanitize = false }
      expect(EditorjsRails.configuration.sanitize).to be false
    end

    it "allows setting css_class_prefix" do
      EditorjsRails.configure { |c| c.css_class_prefix = "custom" }
      expect(EditorjsRails.configuration.css_class_prefix).to eq("custom")
    end

    it "allows setting wrapper_tag" do
      EditorjsRails.configure { |c| c.wrapper_tag = :article }
      expect(EditorjsRails.configuration.wrapper_tag).to eq(:article)
    end

    it "allows registering custom blocks" do
      custom = Class.new(EditorjsRails::Blocks::Base)
      EditorjsRails.configure { |c| c.register_block("custom", custom) }
      expect(EditorjsRails::BlockRegistry.registered?("custom")).to be true
    end
  end

  describe "EditorjsRails.reset!" do
    it "resets configuration to defaults" do
      EditorjsRails.configure { |c| c.sanitize = false }
      EditorjsRails.reset!
      expect(EditorjsRails.configuration.sanitize).to be true
    end
  end
end
