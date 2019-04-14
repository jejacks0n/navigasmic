require "spec_helper"

class MyCustomBuilder < Navigasmic::Builder::Base
  def render
    "_rendered_"
  end
end

describe Navigasmic::ViewHelpers do
  subject { Class.new.extend(described_class) }

  describe ".semantic_navigation" do
    before do
    end

    it "creates the specified builder and calls render on it" do
      expect_any_instance_of(MyCustomBuilder).to receive(:render).and_call_original
      result = subject.semantic_navigation(:primary, class: "primary-nav", builder: MyCustomBuilder)
      expect(result).to eq("_rendered_")
    end

    it "requires a block if there's no definition for the name provided" do
      expect { subject.semantic_navigation(:bar) }.to raise_error(ArgumentError, "Missing block or configuration")
    end

    it "falls back to the default builder if one wasn't provided" do
      expect_any_instance_of(Navigasmic::Builder::ListBuilder).to receive(:render)
      subject.semantic_navigation(:primary)
    end

    it "handles when there is no name" do
      expect_any_instance_of(Navigasmic::Builder::ListBuilder).to receive(:render)
      subject.semantic_navigation({}) do
      end
    end
  end
end
