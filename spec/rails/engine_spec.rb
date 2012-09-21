require 'spec_helper'

describe Navigasmic do

  it "is a module" do
    Navigasmic.should be_a(Module)
  end

  it "has a version" do
    Navigasmic::VERSION.should be_a(String)
  end

  it "defines ViewHelpers" do
    Navigasmic::ViewHelpers.should be_a(Module)
  end

  it "includes ViewHelpers in ActionView::Base" do
    ActionView::Base.new.methods.should include(:semantic_navigation)
  end

end
