require "bundler/gem_tasks"
task :default => :build
task :geminabox do
  `gem inabox -o pkg/web_gui-*.gem`
  `rm pkg/web_gui-*.gem`
end
