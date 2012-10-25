require 'tinymce-rails'
module Tinycms
  class Engine < ::Rails::Engine
    isolate_namespace Tinycms
     
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
    
    initializer "helper" do |app|
      ActiveSupport.on_load(:action_view) do
        include Helper
      end
    end
    
  end
end
