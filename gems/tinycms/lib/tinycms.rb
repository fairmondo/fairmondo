require "tinycms/engine"
require "tinycms/helper"
require "tinycms/configuration"
require "tinymce-rails"

module Tinycms

  def self.configuration
    @configuration ||= Tinycms::Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.tinymce_configuration
    @configuration ||= TinyMCE::Rails::Configuration.load(::Rails.root.join(configuration.tinymce_config_file))
  end

end
