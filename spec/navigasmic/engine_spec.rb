require "spec_helper"

describe Navigasmic::Engine do
  subject { described_class }

  it "includes ViewHelpers in ActionView::Base" do
    if Gem::Version.new(Rails.version) > Gem::Version.new('6.0')
      # https://github.com/ViewComponent/view_component/issues/201#issuecomment-584515642
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      expect(ActionView::Base.new(lookup_context, {}, ApplicationController.new).methods).to include(:semantic_navigation)
    else
      expect(ActionView::Base.new.methods).to include(:semantic_navigation)
    end
  end
end
