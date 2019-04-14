require "spec_helper"

describe Navigasmic::Configuration do
  subject { described_class }

  before do
    @orig_default_builder = subject.default_builder
  end

  after do
    subject.default_builder = @orig_default_builder
  end

  it "has the default configuration" do
    expect(subject.default_builder).to eq(Navigasmic::Builder::ListBuilder)
    expect(subject.definitions).to be_a(Hash)
    expect(subject.builder_configurations).to be_a(Hash)
  end

  it "allows setting various configuration options" do
    subject.default_builder = "_builder_"
    expect(subject.default_builder).to eq("_builder_")
  end

  it "exposes an API for calling configure with a block" do
    Navigasmic.configure do |c|
      c.default_builder = "_custom_default_"
    end

    expect(subject.default_builder).to eq("_custom_default_")
  end

  describe ".sementic_navigation" do
    let(:block) { proc {} }

    it "adds it to the definitions" do
      subject.semantic_navigation(:foo, &block)
      expect(subject.definitions[:foo]).to eq(block)
    end
  end

  describe ".builder" do
    let(:block) { proc {} }

    it "adds it to the builder configurations" do
      subject.builder(:foo, &block)
      expect(subject.builder_configurations["foo"][:default]).to eq(block)
    end

    it "handles passing a hash for the builder" do
      subject.builder(foo: Navigasmic::Builder::CrumbBuilder, &block)
      expect(subject.builder_configurations["Navigasmic::Builder::CrumbBuilder"][:foo]).to eq(block)
    end
  end
end
