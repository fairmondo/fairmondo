$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tinycms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tinycms"
  s.version     = Tinycms::VERSION
  s.authors     = ["Michael Jurke"]
  s.email       = ["m.jurke@gmx.de"]
  s.homepage    = "https://github.com/mjrk/tinycms"
  s.summary     = "A simple 'CMS framework' for few selective CMS sections"
  s.description = "Sometimes you don't need a full-featured CMS with custom layouts for your website but few CMS-like editable sections, e.g. on the start page. " +
                  "Then tinycms might just fit for you! Else, check out refinerycms (https://github.com/refinery/refinerycms)."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency 'jquery-rails'
  s.add_dependency "tinymce-rails"
  s.add_dependency "friendly_id", "~> 4.0.9"

  # Testing
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "rb-inotify", "~> 0.8.8"
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium'
  s.add_development_dependency 'launchy'

  # Dummy app
  s.add_development_dependency 'devise'
  s.add_development_dependency 'sqlite3'
end
