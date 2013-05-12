

module Fairtastic
  module Inputs
    module Base
      module InputSteps
        
        def input_step(step_key, options = {}, &block)
          css = "box"
          css << " default-step" if options[:default_step]
          
          if options[:class]
            options[:class] << " #{step_key}-step-inputs"
          else
            options[:class] = "#{step_key}-step-inputs"
          end
          options[:class] << " white-well" unless options[:class].include?("white-well")
          
          #evaluate the block before setting css class for errors
          block_content = inputs(options.except(:tooltip), &block)
      
          #if we detect an error at an input we set the error class of input step
          #after setting reset the block error
          if @input_step_with_errors
            css << " error-box"
            @input_step_with_errors = false
          end
          
          template.content_tag(:div,
          step_heading_html(step_key, options) << block_content,
          :class => css, :id => "#{step_key}_step", :onclick => "changeBox(this)"
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

          template.content_tag(:div,
          tooltip.html_safe <<
          template.content_tag(:a,
          template.content_tag(:h3,
          "" << prefix << (localized_string(step_key, object, "input_steps") || "")
          ), :id => "link#{step_key}_step", :href => "##{step_key}_step"
          )  << template.content_tag(:div,"",:class=>"clearfix"), :class => "box-legend"
          )
        end

      end
    end
  end
end
