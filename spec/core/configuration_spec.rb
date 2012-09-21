require 'spec_helper'

describe Navigasmic do

  it "has a configuration property" do
    Navigasmic.configuration.should be(Navigasmic::Configuration)
  end

  describe ".setup" do

    it "is defined" do
      Navigasmic.methods.should include(:setup)
    end

    it "yields configuration" do
      config = nil
      Navigasmic.setup { |c| config = c }
      config.should be(Navigasmic::Configuration)
    end

  end

  describe Navigasmic::Configuration do

    subject { Navigasmic::Configuration }

    it "sets the default_builder to ListBuilder" do
      subject.default_builder.should be(Navigasmic::Builder::ListBuilder)
    end

    it "allows configuring builders" do
      subject.builder_configurations.should be_a(Hash)
      subject.builder_configurations.should include('Navigasmic::Builder::ListBuilder')

      subject.builder test_config: Navigasmic::Builder::ListBuilder do
      end

      subject.builder_configurations['Navigasmic::Builder::ListBuilder'].should include(:test_config)
      subject.builder_configurations['Navigasmic::Builder::ListBuilder'][:test_config].should be_a(Proc)
    end

    it "allows naming builder configurations" do
    end

    it "allows defining navigation structures" do
      subject.definitions.should be_a(Hash)
      subject.definitions.should include(:primary)

      subject.semantic_navigation :test_definition do
      end

      subject.definitions.should include(:test_definition)
      subject.definitions[:test_definition].should be_a(Proc)
    end
  end
end
