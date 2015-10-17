# This is a helper that is supposed to be extended by all single table inheritance subclasses.

# Autoloading did not work, thus, I require our custom inputs explicitly
# also see initializers/fairtastic.rb

module Fairtastic
  class FormBuilder < Formtastic::FormBuilder
    # include Fairtastic::Helpers::FieldsetWrapper
    include Fairtastic::Helpers::InputHelper
    include Fairtastic::Inputs::Base::InputSteps

    @@default_form_class = 'formtastic'

    def inputs(*args, &block)
      super(*extended_fieldset_args(*args), &block)
    end

    def semantic_errors(*args)
      args.inject([]) do |_array, method|
        errors = Array(@object.errors[method.to_sym]).to_sentence
        @input_step_with_errors ||= errors.present?
      end
      super
    end

    # Make Accordions red if contains errors
    def semantic_fields_for(record_or_name_or_array, *args, &block)
      relation = @object.send(record_or_name_or_array)
      if relation.is_a?(ActiveRecord::Relation) || relation.is_a?(Array)
        relation.each do |item|
          @input_step_with_errors ||= item.errors.present?
        end
      else
        @input_step_with_errors ||= (relation && relation.errors.present?)
      end
      super
    end

    def nested_inputs_for(association_name, options = {}, &block)
      title = options[:name]
      title = localized_string(association_name, object, nil) if title == true
      title ||= ''

      tooltip = optional_tooltip_html(association_name, options)
      tooltip = template.content_tag(:span, tooltip) if tooltip.present?

      title = template.content_tag(:h4, (title << tooltip).html_safe, class: 'questionnaire-entry')
      title.html_safe << semantic_fields_for(association_name, options, &block)
    end

    private

    def extended_fieldset_args(*args)
      options = args.extract_options!
      if options[:class]
        options[:class] << ' inputs'
      else
        options[:class] = 'inputs'
      end
      args << options
    end
  end
end
