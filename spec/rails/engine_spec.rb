require 'spec_helper'

describe Navigasmic do

  it "is a module" do
    expect(Navigasmic).to be_a(Module)
  end

  it "has a version" do
    expect(Navigasmic::VERSION).to be_a(String)
  end

  it "defines ViewHelpers" do
    expect(Navigasmic::ViewHelpers).to be_a(Module)
  end

  it "includes ViewHelpers in ActionView::Base" do
    expect(ActionView::Base.new.methods).to include(:semantic_navigation)
  end

end
