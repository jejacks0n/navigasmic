require "spec_helper"

describe Navigasmic::Engine do
  subject { described_class }

  it "includes ViewHelpers in ActionView::Base" do
    expect(ActionView::Base.new.methods).to include(:semantic_navigation)
  end
end
