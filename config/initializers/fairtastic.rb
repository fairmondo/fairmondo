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

module Formtastic
  module Inputs
    module Base
      module Html
        def tooltip
          template.content_tag(:span, "" ,:class => "sprite_helper",:title => tooltip_text.html_safe ) if tooltip?
        end

        def tooltip?
          tooltip_text.present? && !tooltip_text.kind_of?(Hash)
        end

        def tooltip_text
          localized_string(method, options[:tooltip], :tooltip)
        end
      end
      module Wrapping
        def input_wrapping(&block)
          template.content_tag(:li,

            [tooltip ,
              template.capture(&block),
              error_html,
              hint_html].join("\n").html_safe,
            wrapper_html_options
          )
        end
      end
    end
  end
end
