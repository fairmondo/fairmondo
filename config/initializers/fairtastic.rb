#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Formtastic
  module Inputs
    module Base
      module Html
        def tooltip
          template.content_tag(:i, "" ,:class => "icon-helper",:title => tooltip_text.html_safe ) if tooltip?
        end

        def tooltip?
          tooltip_text.present? && !tooltip_text.kind_of?(Hash)
        end

        def tooltip_text
          localized_string(method, options[:tooltip], :tooltip)
        end
      end

      module Labelling
         def label_html

          label = render_label? ? builder.label(input_name, label_text, label_html_options) : "".html_safe
          label << tooltip
        end
      end

      module Choices
        def legend_html
          if render_label?
            template.content_tag(:legend,
               label_text << tooltip ,
              label_html_options
            )
          else
            "".html_safe
          end
        end

      end

    end
  end
end
