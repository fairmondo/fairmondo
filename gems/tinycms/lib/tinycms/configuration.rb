module Tinycms
  class Configuration

    attr_accessor :tinymce_config_file, :tinycms_user_accessor, :tinycms_user_admin_callable, :sign_in_path

    def initialize
      @tinymce_config_file    = File.join "config", "tinycms.yml"
    end

  end
end
