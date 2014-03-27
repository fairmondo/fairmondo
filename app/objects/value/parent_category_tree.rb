class ParentCategoryTree
  attr_accessor :first_init

  def initialize category = nil, first_init = true
    @category = category
    @first_init = first_init
  end

  def name
    @category ? @category.name : "Kategorien"
  end

  def to_s
    @category ? @category.slug : ''
  end
  alias_method :id, :to_s

  def children
    if @first_init
      Category.other_category_last.sorted_roots.all.map do |category|
        ParentCategoryTree.new category, false
      end
    else
      []
    end
  end
end
