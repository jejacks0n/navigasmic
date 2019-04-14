require "spec_helper"

describe Navigasmic do
  it "has a configuration property" do
    expect(Navigasmic.configuration).to be(Navigasmic::Configuration)
  end

  describe ".setup" do
    it "is defined" do
      expect(Navigasmic.methods).to include(:setup)
    end

    it "yields configuration" do
      config = nil
      Navigasmic.setup { |c| config = c }
      expect(config).to be(Navigasmic::Configuration)
    end
  end

  describe Navigasmic::Configuration do
    subject { Navigasmic::Configuration }

    it "sets the default_builder to ListBuilder" do
      expect(subject.default_builder).to be(Navigasmic::Builder::ListBuilder)
    end

    it "allows configuring builders" do
      expect(subject.builder_configurations).to be_a(Hash)
      expect(subject.builder_configurations).to include("Navigasmic::Builder::ListBuilder")

      subject.builder test_config: Navigasmic::Builder::ListBuilder do
      end

      expect(subject.builder_configurations["Navigasmic::Builder::ListBuilder"]).to include(:test_config)
      expect(subject.builder_configurations["Navigasmic::Builder::ListBuilder"][:test_config]).to be_a(Proc)
    end

    it "allows naming builder configurations" do
    end

    it "allows defining navigation structures" do
      expect(subject.definitions).to be_a(Hash)
      expect(subject.definitions).to include(:primary)

      subject.semantic_navigation :test_definition do
      end

      expect(subject.definitions).to include(:test_definition)
      expect(subject.definitions[:test_definition]).to be_a(Proc)
    end
  end
end
