#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# We cannot namespace them properly as formtastic's lookup chain would not find them
# see  lib/formtastic/helpers/input_helper.rb
# module Fairtastic
#  module Inputs

class PlainRadioInput < Formtastic::Inputs::RadioInput
  def choice_html(choice)
    opts = input_html_options
    if options[:js_toggle]
      css_class = "#{choice[1]}-" + method.to_s
      opts['data-select-toggle'] ||= css_class
    end

    template.content_tag(
      :label,
      (builder.radio_button(input_name, choice_value(choice), opts.merge(choice_html_options(choice)).merge(required: false)) << choice_label(choice)).html_safe,
      label_html_options.merge(for: choice_input_dom_id(choice), class: nil)
    )
  end

  def wrapper_classes_raw
    super << ' radio'
  end

  def render_label?
    if options[:label]
      true
    else
      false
    end
  end
end
