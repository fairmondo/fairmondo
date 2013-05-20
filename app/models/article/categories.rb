module Article::Categories
  extend ActiveSupport::Concern

  included do


    after_save :send_category_proposal
    attr_accessible :categories_and_ancestors,:category_proposal
     attr_accessor :category_proposal

    # categories refs #154
    has_and_belongs_to_many :categories
    validates :categories, :size => {
      :in => 1..2,
      :add_errors_to => [:categories, :categories_and_ancestors]
    }
    before_validation :ensure_no_redundant_categories # just store the leafs to avoid inconsistencies

    # returns all articles with category_id == nil
    scope :with_exact_category_id, lambda {|category_id = nil|
      return Article.scoped unless category_id.present?
      joins(:articles_categories).where(:articles_categories => {:category_id => category_id})
    }

    scope :with_exact_category_ids, lambda {|category_ids = []|
      category_ids = category_ids.select(&:present?).map(&:to_i)
      # passing and array, rails uses 'IN'-operator instead of '='
      with_exact_category_id(category_ids)
    }

    # for convenience, these methods remove all redundant ancesors from the passed collection
    # e.g. selecting Computer and Hardware, we don't want all articles under Computer but
    # only the subset of Hardware
    scope :with_category_or_descendant_ids, lambda {|category_ids = []|
      category_ids = category_ids.select(&:present?).map(&:to_i)
      return Article.scoped unless category_ids.present?
      with_categories_or_descendants(Category.where(:id => category_ids))
    }

    scope :with_categories_or_descendants, lambda {|categories = []|
      return Article.scoped unless categories.present?
      categories = Article::Categories.remove_category_parents(categories)
      # restults to ("categories"."lft" >= 1 AND "categories"."lft" < 2)
      # see https://github.com/collectiveidea/awesome_nested_set and nested sets in general
      constraints = categories.map{|c| c.self_and_descendants.arel.constraints.first }
      constraint = constraints.pop
      constraints.each do |clause|
        constraint = constraint.or(clause)
      end
      joins(:categories).where(constraint)
    }


  end

  def categories_and_ancestors
    @categories_and_ancestors ||= (categories && categories.map(&:self_and_ancestors).flatten.uniq) || []
  end

  def categories_and_ancestors=(categories)
    if categories.first.is_a?(String) || categories.first.is_a?(Integer)
      categories = categories.select(&:present?).map(&:to_i)
      categories = Category.where(:id => categories)
    end
    # remove entries which parent is not included in the subtree
    # e.g. you selected Hardware but unselected Computer afterwards
    @categories_and_ancestors = categories.select{|c| c.include_all_ancestors?(categories) }
    # remove all parents
    self.categories = Article::Categories.remove_category_parents(@categories_and_ancestors)
  end

  def self.remove_category_parents(categories)
    # does not hit the database
    categories.reject{|c| categories.any? {|other| c!=nil && other.is_descendant_of?(c) } }
  end


  def ensure_no_redundant_categories
    self.categories = Article::Categories.remove_category_parents(self.categories) if self.categories
    true
  end
  private :ensure_no_redundant_categories

  # For Solr searching we need category ids
  def self.search_categories(categories)
    ids = []
    categories = Article::Categories.remove_category_parents(categories)

    categories.each do |category|
     category.self_and_descendants.each do |fullcategories|
        ids << fullcategories.id
      end
    end
    ids
  end

  def send_category_proposal
     if self.category_proposal.present?
        ArticleMailer.category_proposal(self.category_proposal).deliver
     end
  end

end