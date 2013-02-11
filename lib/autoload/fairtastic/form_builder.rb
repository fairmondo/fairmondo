# Autoloading did not work, thus, I require our custom inputs explicitly

#require_relative "inputs/plain_radio_input"

module Fairtastic
  
  class FormBuilder < FormtasticBootstrap::FormBuilder
     
     include Fairtastic::Helpers::FieldsetWrapper
     
     def input_with_purpose(*args)
       template.content_tag(:li,
         input(*extended_radio_args(*args)) << input(*pupose_args(*args)),
         :class => "questionnaire-entry"
       )
     end
     
     def input_with_explanation(*args)
       template.content_tag(:li,
         input(*extended_radio_args(*args)) << input(*explanation_args(*args)),
         :class => "questionnaire-entry"
       )
     end
     
     # TODO find out how to customize inputs-method (pluralversion), move steps to its own class 
     def input_step(step_key, options = {}, &block)
       css = "input-step"
       css << " default-step" if options[:default_step]
       
       template.content_tag(:div,
         step_heading_html(step_key, options) <<
         inputs(options, &block),
         :class => css, :id => "#{step_key}_step"
       )
     end
     
     private
     
     def next_prefix
       @prefix_count ||= 0
       @prefix_count += 1
       I18n.t("formtastic.input_steps.#{object_name}.prefix", :count => @prefix_count)
     end
     
     def step_heading_html(step_key, options = {})
       prefix = ""
       unless options[:prefix] == false
         prefix = next_prefix
         prefix << " "
       end
       
       template.content_tag(:div,
         template.content_tag(:a,
           template.content_tag(:h3,
             template.content_tag(:i, "", :class => "icon-play icon-white") <<
             prefix + I18n.t("formtastic.input_steps.#{object_name}.#{step_key}")
           ), :href => "##{step_key}_step"
         ), :class => "step-legend"
         
       )
     end 
     
     def extended_radio_args(*args)
       options = args.extract_options!
       options[:prepend_label] = true
       options[:as] ||= :plain_radio
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