# Autoloading did not work, thus, I require our custom inputs explicitly

#require_relative "inputs/plain_radio_input"

module Fairtastic
  
  class FormBuilder < FormtasticBootstrap::FormBuilder
     
     include Fairtastic::Helpers::FieldsetWrapper
     
     def input_with_explanation(*args)
       template.content_tag(:li,
         input(*args) << input(*explanation_args(*args))
       )
     end
     
     private 
     def explanation_args(*args)
       options = args.extract_options!
       options[:as] = :text
       args[0] = (args[0].to_s << "_explanation").to_sym
       args << options
       args
     end
     
  end
  
end