class CheckBoxTreeInput < FormtasticBootstrap::Inputs::CheckBoxesInput
 
  def to_html
    if options[:prepend_label]
      l = template.content_tag(:div, control_label_html, :class => "tree-label")
    else
      l = "".html_safe
    end
    
    control_group_wrapping do
      l << recursive_to_html(collection, true)
    end
  end
  
  def collection
    # Return if we have a plain string
    return raw_collection if raw_collection.instance_of?(String) || raw_collection.instance_of?(ActiveSupport::SafeBuffer)

    # Return if we have an Array of strings, fixnums or arrays
    return raw_collection if (raw_collection.instance_of?(Array) || raw_collection.instance_of?(Range)) &&
                         [Array, Fixnum, String].include?(raw_collection.first.class) &&
                         !(options.include?(:member_label) || options.include?(:member_value))

    raw_collection.map { |o| label_value_children_triple(o) }
  end
    
  def tree_wrapping(&block)
    template.content_tag(:ul, template.capture(&block).html_safe)
  end
  
  # the li-element is for the tree
  # the span element wrapps the content (e.g. for borders)
  def tree_item_wrapping(&block)
    template.content_tag(:li,
      template.content_tag(:span,
      template.capture(&block)
      )
    ).html_safe
  end

  def choice_html(choice) 
    template.content_tag(:label, choice_label(choice),
        label_html_options.merge(choice_label_html_options(choice))) <<
      (hidden_fields? ? check_box_with_hidden_input(choice) : check_box_without_hidden_input(choice)).html_safe <<
      template.content_tag(:i, "", :class => 'icon-ok')
  end
  
  private

  def children_method
    options[:children_method] || :children 
  end
  
  def recursive_to_html(collection, first = false)
    if first
      h = hidden_field_for_all 
    else
      h = "".html_safe
    end
    if collection.blank?
      h
    else 
      h <<
      tree_wrapping do 
        controls_wrapping do
          collection.map { |choice|
            tree_item_wrapping do 
              choice_html(choice) << 
              recursive_to_html(choice.last)
            end
          }.join("\n").html_safe
        end
      end
    end
  end
  
  def label_value_children_triple(o)
    [send_or_call(label_method, o), send_or_call(value_method, o), o.send(children_method).map{|c| label_value_children_triple(c)}]
  end
  
end
