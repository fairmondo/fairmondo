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

          template.content_tag(:div,
          step_heading_html(step_key, options) <<
          inputs(options.except(:tooltip), &block),
          :class => css, :id => "#{step_key}_step"
          )
        end

        private

        def next_prefix
          @prefix_count ||= 0
          @prefix_count += 1
          I18n.t("formtastic.input_steps.#{object_name}.prefix", :count => @prefix_count)
        end

        def input_step_help_html(step_key, options = {})
          if options[:tooltip] == true
            tooltip_html(I18n.t("formtastic.input_steps.#{object_name}.#{step_key}_hint"))
          elsif options[:tooltip].is_a?(String)
            tooltip_html(options[:tooltip])
          else
            ""
          end
        end

        def step_heading_html(step_key, options = {})
          prefix = ""
          unless options[:prefix] == false
            prefix = next_prefix
            prefix << " "
          end
          tooltip = input_step_help_html(step_key, options)

          template.content_tag(:div,
          tooltip.html_safe <<
          template.content_tag(:a,
          template.content_tag(:h3,
          prefix << I18n.t("formtastic.input_steps.#{object_name}.#{step_key}")
          ), :href => "##{step_key}_step"
          )  << template.content_tag(:div,"",:class=>"clearfix"), :class => "box-legend"
          )
        end

      end
    end
  end
end
