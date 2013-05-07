# We cannot namespace them properly as formtastic's lookup chain would not find them
# see  lib/formtastic/helpers/input_helper.rb
#module Fairtastic
#  module Inputs
class PlainCheckBoxesInput < FormtasticBootstrap::Inputs::CheckBoxesInput

  def to_html
    if options[:prepend_label]
      control_label_html
      l = template.content_tag(:div, control_label_html, :class => "question")
    else
      l = "".html_safe
    end

    control_group_wrapping do
      l <<
      hidden_field_for_all <<
      controls_wrapping do
        collection.map { |choice|
          choice_html(choice)
        }.join("\n").html_safe
      end
    end
  end

end
