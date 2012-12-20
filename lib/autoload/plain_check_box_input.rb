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

  
end
