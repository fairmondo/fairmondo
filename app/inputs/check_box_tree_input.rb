class CheckBoxTreeInput < Formtastic::Inputs::CheckBoxesInput
  def to_html
    tooltip_link = tooltip
    options[:tooltip] =false
    input_wrapping do
        label_html <<
        tooltip_link <<
        hidden_field_for_all <<
         template.content_tag(:div,
          recursive_to_html(collection, true) ,:class => "check_box_tree_contents")

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

  # the li-element is for the tree
  # the span element wrapps the content (e.g. for borders)
  def tree_item_wrapping(tree_class,&block)
    template.content_tag(
      :li,
      template.content_tag(
        :span,
        template.capture(&block)
      ),
      :class => tree_class
    ).html_safe
  end



  def choice_html(choice)
    (hidden_fields? ? check_box_with_hidden_input(choice) : check_box_without_hidden_input(choice)).html_safe <<
    template.content_tag(:label,  choice_label(choice), label_html_options.merge(:for => choice_input_dom_id(choice)))

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
      h <<   collection.map { |choice|
                   recursive = recursive_to_html(choice.last)

                      choices_wrapping do
                         choices_group_wrapping do
                            tree_item_wrapping(( recursive.empty? ? "leaf-item" : "tree-item" ).html_safe) do
                              choice_html(choice) <<
                              recursive
                            end
                          end
                      end

                }.join("\n").html_safe

    end

  end

  def label_value_children_triple(o)
    [send_or_call(label_method, o), send_or_call(value_method, o), o.send(children_method).map{|c| label_value_children_triple(c)}]
  end

  def wrapper_classes_raw
    super << " check_boxes"
  end
end
