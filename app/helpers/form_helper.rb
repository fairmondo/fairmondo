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
        fields.semantic_fields_for item.id.to_s.to_sym , item do |item_fields|
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

end
