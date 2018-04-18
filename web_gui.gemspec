# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "web_gui/version"

Gem::Specification.new do |spec|
  spec.name="web_gui"
  spec.version=WebGui::VERSION
  spec.authors=["pjht"]
  spec.email=["pjht@users.noreply.github.com"]
  spec.summary= "A GUI framework for ruby based around the web browser"
  spec.homepage="https://github.com/pjht/web_gui"
  spec.files=["lib/web_gui.rb","lib/main.js"]+Dir.glob("lib/web_gui/*.rb")
  spec.bindir="exe"
  spec.executables=spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths=["lib"]
end
