begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

# setup the dummy app
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

# useful bundler gem tasks
Bundler::GemHelper.install_tasks

# load in rspec tasks
# task "db:test:prepare" => "app:db:test:prepare"
load "rspec/rails/tasks/rspec.rake"

# namespace :spec do
#   [:engine].each do |sub|
#     desc "Run the code examples in spec/#{sub}"
#     RSpec::Core::RakeTask.new(sub => "db:test:prepare") do |t|
#       t.pattern = "./spec/#{sub}/**/*_spec.rb"
#     end
#   end
# end

# setup the default task
Rake::Task["default"].prerequisites.clear
Rake::Task["default"].clear
task default: [:spec]
