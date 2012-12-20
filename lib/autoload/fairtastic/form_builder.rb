# Autoloading did not work, thus, I require our custom inputs explicitly

#require_relative "inputs/plain_radio_input"

module Fairtastic
  
  class FormBuilder < FormtasticBootstrap::FormBuilder
     
     include Fairtastic::Helpers::FieldsetWrapper
=begin
     def inputs(*args)
       hint = args.last.is_a?(Hash) && args.last[:hint] 
       if hint
         l = hint_html
       else
         l = "".html_safe
       end
       l << super
     end
=end
     
     def input_with_explanation(*args)
       template.content_tag(:li,
         input(*explanation_radio_args(*args)) << input(*explanation_args(*args)),
         :class => "questionnaire-entry"
       )
     end
     
     private 
     
     def explanation_radio_args(*args)
       options = args.extract_options!
       options[:prepend_label] = true
       options[:as] ||= :plain_radio
       args << options
     end
     
     def explanation_args(*args)
       options = args.extract_options!
       options[:as] = options[:explanation_as] || :text
       options[:label] = I18n.t('formtastic.labels.questionnaire.explanation')
       args[0] = (args[0].to_s << "_explanation").to_sym
       args << options
     end
     
  end
  
end