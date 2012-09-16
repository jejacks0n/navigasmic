module Navigasmic
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../', __FILE__)

      desc "Installs the Navigasmic initializer into your application."

      def copy_initializer
        copy_file 'templates/initializer.rb', 'config/initializers/navigasmic.rb'
      end

      def display_readme
        readme 'POST_INSTALL' if behavior == :invoke
      end
    end
  end
end
