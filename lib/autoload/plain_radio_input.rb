# We cannot namespace them properly as formtastic's lookup chain would not find them  
# see  lib/formtastic/helpers/input_helper.rb
#module Fairtastic
#  module Inputs
class PlainRadioInput < FormtasticBootstrap::Inputs::RadioInput

  def to_html
    control_group_wrapping do
      controls_wrapping do
        collection.map { |choice|
          choice_html(choice)
        }.join("\n").html_safe
      end
    end
  end
  
  def choice_html(choice)
    builder.radio_button(input_name, choice_value(choice), input_html_options.merge(choice_html_options(choice)).merge(:required => false)) <<
      template.content_tag(:label,
        choice_label(choice),
        label_html_options.merge(choice_label_html_options(choice))
      ) 
  end

  
#  def wrapper_html_options
#    super.tap do |options|
#      options[:class] = options[:class].gsub("radio_buttons", "plain_radio_buttons")
#    end
#  end

  
end
