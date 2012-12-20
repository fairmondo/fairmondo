module Fairtastic 
  module Helpers
    module FieldsetWrapper

      include FormtasticBootstrap::Helpers::FieldsetWrapper

      def field_set_and_list_wrapping(*args, &block) #:nodoc:
        contents = args.last.is_a?(::Hash) ? '' : args.pop.flatten
        html_options = args.extract_options!
        if html_options[:class]
          html_options[:class] << " well"
        else
          html_options[:class] = "well"
        end

        if block_given?
          contents = if template.respond_to?(:is_haml?) && template.is_haml?
            template.capture_haml(&block)
          else
            template.capture(&block)
          end
        end

        # Ruby 1.9: String#to_s behavior changed, need to make an explicit join.
        contents = contents.join if contents.respond_to?(:join)

        legend = field_set_legend(html_options)
        fieldset = template.content_tag(:fieldset,
          Formtastic::Util.html_safe(contents), 
          html_options.except(:builder, :parent, :name)
        )
        fieldset = Formtastic::Util.html_safe(legend) + fieldset  

        fieldset
      end
      
      def field_set_legend(html_options)
        legend = (html_options[:name] || '').to_s
        legend %= parent_child_index(html_options[:parent]) if html_options[:parent]
        if html_options[:hint]
          legend += template.content_tag(:span, Formtastic::Util.html_safe(html_options[:hint]), :class => 'help-block')
        end
        legend = template.content_tag(:h4, template.content_tag(:span, Formtastic::Util.html_safe(legend))) unless legend.blank?
        legend
      end

    end
  end
end