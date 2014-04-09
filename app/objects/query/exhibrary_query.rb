# What used to be Exhibitions are now Libraries
class ExhibraryQuery

  #scope :one_day_exhibited, lambda { where("library_elements.exhibition_date IS NULL OR exhibits.exhibition_date >= ?", DateTime.now - 1.day) }
  # scope :older_exhibited, lambda {  }
  #scope :oldest_first, order("library_elements.created_at ASC")
  #scope :article_active, joins(:article).where(" articles.state = 'active' ").includes(:article => [:images,:seller])
  # scope :related_article_active, where("related_articles_exhibits.state = 'active' ").joins(:related_article).includes(:related_article => [:images,:seller])

  def initialize exhibition_name
    @exhibition_name = exhibition_name
    @library = Library.where(exhibition_name: exhibition_name).first
    @relation = LibraryElement.scoped.where(library_id: @library.id).includes(article: [:images,:seller]).joins(:article).where("articles.state = 'active'") if @library
  end

  def find count = 2
    return [] unless @library

    exhibits = ordered_active_one_day_exhibited count
    exhibits.each do |exhibit|
      set_exhibition_date_of exhibit
    end
    exhibits = fill_exhibits( exhibits, count ) unless exhibits.length >= count
    exhibits.map{ |exhibit| exhibit.article }
  end

  private
    def ordered_active_one_day_exhibited limit
      @relation.where("library_elements.exhibition_date IS NULL OR library_elements.exhibition_date >= ?", DateTime.now - 1.day).order("library_elements.created_at ASC").limit limit
    end

    def set_exhibition_date_of library_element
      LibraryElement.find(library_element.id).update_attribute :exhibition_date, DateTime.now
    end

    # Conditional scope, used when one_day_exhibited doesn't return enough results
    # @return [Array] exhibits plus older ones to fill empty spaces
    def fill_exhibits exhibits, count
      filler_count = count - exhibits.length
      exhibits + @relation.where("library_elements.id NOT IN (?)", exhibits.map{|e| e.id } + [0] ).where("library_elements.exhibition_date IS NOT NULL AND library_elements.exhibition_date < ?", DateTime.now - 1.day).order("RANDOM()").limit(filler_count)
    end
end