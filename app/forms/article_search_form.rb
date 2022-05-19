#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleSearchForm
  include ActiveData::Model
  extend Enumerize
  delegate :formated_prices, to: :price_range_parser

  attribute :q, type: String
  attribute :fair, type: Boolean
  attribute :ecologic, type: Boolean
  attribute :small_and_precious, type: Boolean
  attribute :swappable, type: Boolean
  attribute :borrowable, type: Boolean

  attribute :condition, type: String
  attribute :category_id, type: Integer
  attribute :exclude_category_ids, type: Array
  attribute :zip, type: String
  attribute :order_by, type: String,
                       default_blank: true
  attribute :search_in_content, type: Boolean
  attribute :price_from, type: String
  attribute :price_to, type: String
  attribute :transport_bike_courier, type: Boolean

  enumerize :condition, in: [:new, :old]
  enumerize :order_by, in: [:newest, :cheapest, :most_expensive, :old, :new, :fair, :ecologic, :small_and_precious, :most_donated]

  def searched_category category_id = self.category_id
    @searched_category ||= Category.includes(:children).find(category_id.to_i) rescue nil
  end

  def search page
    if page.to_i > 1000
      return [].page(1)
    end
    @search = ArticleSearch.search(self)
    results = @search.result.page(page).per(Kaminari.config.default_per_page)
    results.to_a # dont get rid of this as it will trigger the request and the rescue block can come in
    results
  rescue Faraday::ClientError
    search_results_for_error_case page
  rescue StandardError
    search_results_for_error_case page
  end

  # For the category tree to display wich categories have which counts
  def category_article_count category_id
    @search.category_facets[category_id.to_s] || 0
  end

  def search_by_term?
    self.q.present?
  end

  # Did this form get request parameters or is this an empty search where
  # someone just wants to look around? (category doesn't count)
  def search_request?
    !filter_attributes.reject { |k, _v| k == "category_id" }.empty?
  end

  # Check if an attribute has a specific value and if it is set exclusively,
  #
  #   exclusive_value?(:fair, true)
  #   # true, if the fair filter and no other attributes are set
  def exclusive_value?(key, value)
    attrs = filter_attributes
    attrs.length == 1 && attrs[key.to_s] == value
  end

  def fresh?
    filter_attributes.empty?
  end

  def change changes
    clean_hash self.attributes.merge(changes.stringify_keys)
  end

  def flip parameter
    self.change(parameter => !self.send(parameter))
  end

  def keep
    filter_attributes
  end

  def search_form_attributes
    filter_attributes.reject { |k, _v| %w(q category_id).include?(k) }
  end

  def category_collection
    categories = Category.other_category_last.sorted.roots.to_a
    categories.push(Category.find(self.category_id)) if self.category_id.present?
    categories
  end

  def wegreen_search_string
    if search_by_term?
      q
    elsif searched_category
      searched_category.name
    else
      nil
    end
  end

  def price_range_parser
    @price_range ||= PriceRangeParser.new(price_from, price_to)
  end

  def price_range
    # set the values for proper formatting
    self.price_from, self.price_to = price_range_parser.form_values
    { gte: price_range_parser.from_cents, lte: price_range_parser.to_cents }
  end

  private

  def search_results_for_error_case page
    ArticlePolicy::Scope.new(nil, Article).resolve.page(page)
  end

  def filter_attributes
    clean_hash self.attributes
  end

  def clean_hash hash
    hash.select { |_k, v| v != nil && v != false }
  end
end
