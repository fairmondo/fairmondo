#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
# We cannot namespace them properly as formtastic's lookup chain would not find them
# see  lib/formtastic/helpers/input_helper.rb
#module Fairtastic
#  module Inputs
class PlainCheckBoxInput < Formtastic::Inputs::BooleanInput

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

  def wrapper_classes_raw
    super << " boolean"
  end
end
