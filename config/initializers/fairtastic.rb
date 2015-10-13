#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
