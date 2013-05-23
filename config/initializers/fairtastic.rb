module Formtastic
  module Inputs
    module Base
      module Html
        def tooltip
          template.content_tag(:a, "",:class => "input-tooltip","data-html" => "true", "data-content" => tooltip_text.html_safe) if tooltip?
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
          template.content_tag(
            :li,
            [template.capture(&block), tooltip, error_html, hint_html].join("\n").html_safe,
            wrapper_html_options
          )
        end
      end
    end
  end
end