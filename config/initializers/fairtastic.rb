# I did not find a way to extend the bootstrap_wrapping by subclassing 
# because due to the heavy use of autoload we had to subclass all formtastic classes
# like formtastic_bootstrap does.
# TODO make this a ActiveRecord::Concern hook
module FormtasticBootstrap
  module Inputs
    
    Base.send(:include, Fairtastic::Inputs::Base::Tooltips)
    
    Base.module_eval do
      
      def controls_wrapping(&block)
        template.content_tag(:div, (template.capture(&block) << tooltip_html).html_safe, controls_wrapper_html_options)
      end
      
    end
  end
end
