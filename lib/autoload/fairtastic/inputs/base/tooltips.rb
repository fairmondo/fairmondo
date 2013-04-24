module Fairtastic
  module Inputs
    module Base
      module Tooltips 

        def tooltip_html(tooltip_content = options[:tooltip])
          
          if tooltip_content 
      
            tooltip_content = localized_string(method, nil, "tooltips") || "" if options[:tooltip] == true
            
            template.content_tag(:a,
              "",
              :class => "input-tooltip", "data-content" => tooltip_content.html_safe)
          else
            ""
          end
        end
        
        def optional_tooltip_html(method, options = {})
          t = options[:tooltip]
          t = localized_string(method, nil, "tooltips") if options[:tooltip] == true
          tooltip_html(t).html_safe
        end        
        
      end
    end
  end
end
