# We cannot namespace them properly as formtastic's lookup chain would not find them
# see  lib/formtastic/helpers/input_helper.rb
#module Fairtastic
#  module Inputs
class PlainRadioInput < FormtasticBootstrap::Inputs::RadioInput

  def to_html
    if options[:prepend_label]
      control_label_html
      l = template.content_tag(:div, control_label_html, :class => "question")
    else
      l = "".html_safe
    end

    control_group_wrapping do
      l <<
      controls_wrapping do
        collection.map { |choice|
          choice_html(choice)
        }.join("\n").html_safe << hint_html
      end
    end
  end

  def choice_html(choice)
    opts = input_html_options
    if options[:js_toggle]
      css_class = "#{choice[1]}-input-fields"
      opts["data-select-toggle"] ||= css_class
    end
    builder.radio_button(input_name, choice_value(choice), opts.merge(choice_html_options(choice)).merge(:required => false)) <<
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
