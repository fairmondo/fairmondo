# class CategorySelectForm
#   extend ActiveModel::Naming
#   extend Enumerize
#   include Virtus.model
#   include ActiveModel::Conversion

#   def persisted?
#     false
#   end

#   def initialize parent_category
#     @parent_category = parent_category
#   end

#   def self.category_select_form_attrs
#     [:category_id]
#   end


#   attribute :category_id, Integer

#   def collection
#     @parent_category.children.map { |child| [child.name, child.id] }
#   end

#   def id_array
#     parent_category.children.map { |child| child.id }
#   end

#   def self.categories_for_filter form
#     if form.object.category_id.present?
#       Category.find(form.object.category_id).self_and_ancestors.map(&:id).to_json
#     else
#       [].to_json
#     end
#   end
# end