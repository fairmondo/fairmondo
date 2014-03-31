# Object that returns values for category tree displays. Generally two levels deep.
# Should have the same public API as Category.
class ParentCategoryTree
  # save the params and set up tree
  def initialize category = nil, first_level = true
    @category = category
    @first_level = first_level
  end

  # inherent name, name from param, or default
  def name
    current_category ? @category.name : "Alle Kategorien"
  end

  # for link building with category_path(this): slug for show or empty string for index
  def to_s
    @category ? @category.slug : ''
  end
  alias_method :id, :to_s

  # gives tree leaves to compute next
  def children
    if current_category && @first_level # if a category was given we need no defaulting magic
      current_category.children # this can get more that 2 levels deep
    elsif @first_level # no category given but we need a second level: get all roots
      Category.other_category_last.sorted_roots.all.map do |category|
        ParentCategoryTree.new category, false
      end
    else # we are on level two and don't want to deliver a level three
      []
    end
  end

  private
    # If there is no second level, get the parent to be the first one
    def current_category
      @current_category ||=
        if @first_level and @category and @category.children.empty?
          @category.parent
        else
          @category
        end
    end
end
