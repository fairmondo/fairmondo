# Autoloading did not work, thus, I require our custom inputs explicitly

# also see initializers/fairtastic.rb

module Fairtastic
  class FormBuilder < Formtastic::FormBuilder
    #include Fairtastic::Helpers::FieldsetWrapper
    include Fairtastic::Helpers::InputHelper
    include Fairtastic::Inputs::Base::InputSteps
    
    def inputs(*args, &block)
      super(*extended_fieldset_args(*args),&block)
    end
    
    def input_with_purpose(*args)
       template.content_tag(:li,
      template.content_tag(:fieldset, 
      template.content_tag(:ol,
      input(*extended_radio_args(*args)) << input(*pupose_args(*args))),:class => "inputs"),
      :class => "questionnaire-entry"
      )
      
      
    end
    
    def semantic_errors(*args)   
      args.inject([]) do |array, method|
          errors = Array(@object.errors[method.to_sym]).to_sentence
          @input_step_with_errors ||=errors.present?
      end
      super
      
    end

    def input_with_explanation(*args)
     
        
    
      template.content_tag(:li,
      template.content_tag(:fieldset, 
      template.content_tag(:ol,
       input(*extended_radio_args(*args)) <<
         input(*explanation_args(*args))),:class => "inputs"),
      :class => "questionnaire-entry"
      )
    end
         
    def nested_inputs_for(association_name, options = {}, &block)
      title = options[:name]
      title = localized_string(association_name, object, nil) if title == true
      title ||= ""
      
      tooltip = optional_tooltip_html(association_name, options)
      tooltip = template.content_tag(:span, tooltip) if tooltip.present?
      
      title = template.content_tag(:h5, (title << tooltip).html_safe, :class => "questionnaire-entry")
      title.html_safe << semantic_fields_for(association_name, options, &block)
    end

    private

    def extended_radio_args(*args)
      options = args.extract_options!
      options[:as] ||= :plain_radio
      options[:label] = true
      args << options
    end
    
    def extended_fieldset_args(*args)
      options = args.extract_options!
      if options[:class] 
        options[:class] << " inputs"
      else
         options[:class] = "inputs"
      end
      args << options
    end

    def pupose_args(*args)
      options = args.extract_options!
      options[:as] = options[:purpose_as] || :plain_check_boxes
      args[0] = (args[0].to_s << "_purposes").to_sym
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