class ArticleSearchForm
  extend ActiveModel::Naming
  extend Enumerize
  include Virtus.model
  include ActiveModel::Conversion

  def self.article_search_form_attrs
    [:q,:fair,:ecologic, :small_and_precious, :condition,:category_id, :zip, :order_by, :search_in_content]
  end

  attribute :q,String
  attribute :fair, Boolean
  attribute :ecologic, Boolean
  attribute :small_and_precious, Boolean
  attribute :condition, String
  enumerize :condition, in: [:new, :old]
  attribute :category_id, Integer
  attribute :zip, String
  attribute :order_by, String
  enumerize :order_by, in: [:newest,:cheapest,:most_expensive,:old,:new,:fair,:ecologic,:small_and_precious,:most_donated]
  #   => :newest,"Preis aufsteigend" => :cheapest,"Preis absteigend" => :most_expensive
  attribute :search_in_content, Boolean

  def persisted?
    false
  end

  def searched_category
    Category.find(self.category_id)
  rescue
    nil
  end

  def search page
    query = self
    articles = Article.search(:page => page,:per_page => Kaminari.config.default_per_page) do
      if query.search_by_term?
        query do
          boolean do
            should { match "title.search", query.q, fuzziness: 0.8 , :boost => 20, :zero_terms_query => 'all'}
            should { match :content,  query.q  } if query.search_in_content
            should { match :friendly_percent_organisation_nickname,  query.q, :fuzziness => 0.7, :boost => 50}
            should { match :gtin, query.q , :boost => 100}

          end
        end

      else
        query { all }
      end

      filter :term, :fair => true if query.fair
      filter :term, :ecologic => true if query.ecologic
      filter :term, :small_and_precious => true  if query.small_and_precious
      filter :term, :condition => query.condition  if query.condition
      filter :terms, :categories => [query.category_id] if query.category_id.present?
      filter :term, :zip => query.zip if query.zip.present?

      case query.order_by
      when "newest"
        sort { by :created_at, :desc  }
      when "cheapest"
        sort { by :price, :asc }
      when "most_expensive"
        sort { by :price, :desc }
      when "old"
        sort { by :condition, :desc }
      when "new"
        sort { by :condition, :asc }
      when "fair"
        sort { by :fair, :desc }
      when "ecologic"
        sort { by :ecologic, :desc }
      when "small_and_precious"
        sort { by :small_and_precious, :desc }
      when "most_donated"
        sort { by :friendly_percent, :desc }
      else
        # Sort by score
        sort { by :created_at, :desc  } unless query.search_by_term?
      end
    end
  end

  def autocomplete
    query = self
    search = Article.search do
      query do
        match "title.decomp", query.q, fuzziness: 0.9
      end
      highlight "title.decomp", :options => { number_of_fragments: 0, pre_tags: ["<b>"], post_tags: ["</b>"]}
      suggest :typos do
        text query.q
        term "title.decomp", :suggest_mode => 'popular', :sort => 'frequency' , :analyzer => :simple, size: 3
      end
    end
    suggestions = search.suggestions.texts.map { |suggest| {:label => suggest , :value => suggest }}
    suggestions += search.results.map{ |result| { :label => result.highlight["title.decomp"].first, :value => result.title} }
  end


  def self.categories_for_filter form
    if form.object.category_id.present?
      Category.find(form.object.category_id).self_and_ancestors.map(&:id).to_json
    else
      [].to_json
    end
  end


  def search_by_term?
    self.q && !self.q.empty?
  end

end