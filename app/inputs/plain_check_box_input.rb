# We cannot namespace them properly as formtastic's lookup chain would not find them
# see  lib/formtastic/helpers/input_helper.rb
#module Fairtastic
#  module Inputs
class PlainCheckBoxInput < FormtasticBootstrap::Inputs::BooleanInput

  def to_html
    control_group_wrapping do
      hidden_field_html <<
      controls_wrapping do
        label_with_nested_checkbox << hint_html
      end
    end
  end

  def label_with_nested_checkbox
    builder.label(
      method,
      label_text_with_embedded_checkbox,
      label_html_options.tap do |options|
        options[:class] << "checkbox"
      end
    )
  end

  def check_box_html
    opts = input_html_options
    if options[:js_toggle]
      css_class = options[:js_toggle].is_a?(String) ? options[:js_toggle] : "#{method}-input-fields"
      opts["data-select-toggle"] ||= css_class
    end
    template.check_box_tag("#{object_name}[#{method}]", checked_value, checked?, opts)
  end

end
