module Navigasmic::Builder
  class CrumbBuilder < Base
    class Configuration < Base::Configuration
    end

    def initialize(context, name, options, &block)
      super
    end

    def render
    end

    def group(label = nil, options = {}, &block)
    end

    def item(label, *args, &block)
    end

  end
end
