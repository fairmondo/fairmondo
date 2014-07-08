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
module Fairtastic
  module Inputs
    module Base
      module InputSteps

        def input_step(step_key, options = {}, &block)
          css = "Accordion-item"

          if options[:class]
            options[:class] << " #{step_key}-step-inputs"
          else
            options[:class] = "#{step_key}-step-inputs"
          end

          #evaluate the block before setting css class for errors
          block_content = inputs(options.except(:tooltip), &block)

          #if we detect an error at an input we set the error class of input step
          #after setting reset the block error
          if @input_step_with_errors || options[:has_errors]
            css << " Accordion-item--errors"
            @input_step_with_errors = false
          end

          template.content_tag(:div,
          step_heading_html(step_key, options) << template.content_tag(:div,block_content, :class => "Accordion-content" ) ,
          :class => css, :id => "#{step_key}_step"
          )


        end

        private

        def next_prefix
          @prefix_count ||= 0
          @prefix_count += 1
          localized_string("prefix", object, "input_steps", :count => @prefix_count) || ""
        end

        def step_heading_html(step_key, options = {})
          prefix = ""
          unless options[:prefix] == false
            prefix = next_prefix
            prefix << " "
          end
          tooltip = optional_tooltip_html("#{step_key}_input_step", options)
          template.content_tag(:a,   template.content_tag(:i,"", :class => "icon-arrow") << prefix.html_safe << (localized_string(step_key, object, "input_steps") || "").html_safe << tooltip, :href => "##{step_key}_step" ,:class => "Accordion-header")


        end

        def optional_tooltip_html(method, options = {})
          tooltip_text = options[:tooltip]
          tooltip_text = localized_string(method, nil, "tooltips") if options[:tooltip] == true
          if tooltip_text
            template.content_tag(:span, "" ,:class => "sprite_helper" ,:title => tooltip_text)
          else
            ""
          end
        end

      end
    end
  end
end
