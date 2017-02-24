#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module FormHelper
  # Creates semantic fields for an activerecord relation without having to deal with
  # accepts_nested_attributes_for. The fields will generate params like this:
  # _key_: { _id_ => { fields } }
  # Example: business_transactions: { 1: { selected_transport: :pickup } }
  # @api public
  # @param form [FormBuilder]
  # @param key [Symbol]
  # @param relation [ActiveRecord::Relation]
  # @param &block [Block]
  # @return [String]
  def semantic_relation_field_for form, key, relation, &block
    form.semantic_fields_for key do |fields|
      items = relation.collect do |item|
        fields.semantic_fields_for item.id.to_s.to_sym, item do |item_fields|
          capture(item, item_fields, &block)
        end
      end
      safe_join(items)
    end
  end

  ### Forms

  # Default input field value -> param or current_user.*
  # @api public
  # @param field [Symbol]
  # @return [String, nil]
  def default_form_value field, target = current_user
    default_value(field) || target.send(field)
  end

  # Default input field value -> param or nil
  # @api public
  # @param field [Symbol]
  # @return [String, nil]
  def default_value field
    if params['business_transaction'] && params['business_transaction'][field]
      params['business_transaction'][field]
    else
      nil
    end
  end

  # JS used in icheck checkboxes onclick to open a new window with the contents of a link
  # @param target [String] path
  # @return [String] JS code
  def on_click_open_link_in_label target
    "var e=arguments[0] || window.event;
      window.open('#{target}','_blank');
      e.cancelBubble = true;
      e.stopPropagation();
      return false;"
  end

  # Checkboxlink Helper for agbs
  def checkbox_link_helper label, target
    link_to label, target, target: '_blank', onclick: on_click_open_link_in_label(target)
  end

  def acquire_or_create_contact_form
    @contact_form || ContactForm.new
  end
end
