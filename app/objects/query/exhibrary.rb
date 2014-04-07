class Exhibrary

  #scope :one_day_exhibited, lambda { where("library_elements.exhibition_date IS NULL OR exhibits.exhibition_date >= ?", DateTime.now - 1.day) }
  # scope :older_exhibited, lambda { where("exhibits.exhibition_date IS NOT NULL AND exhibits.exhibition_date < ?", DateTime.now - 1.day).order("RANDOM()") }
  #scope :oldest_first, order("library_elements.created_at ASC")
  #scope :article_active, joins(:article).where(" articles.state = 'active' ").includes(:article => [:images,:seller])
  # scope :related_article_active, where("related_articles_exhibits.state = 'active' ").joins(:related_article).includes(:related_article => [:images,:seller])

  def initialize relation = LibraryElement.scoped
    @relation = relation
  end

  def find library_id, count = 2
    exhibits = ordered_active_one_day_exhibited library_id, count
    exhibits.each do |exhibit|
      set_exhibition_date_of exhibit
    end
    exhibits = fill_exhibits( exhibits, queue, count ) unless exhibits.length >= count
    exhibits.map{ |exhibit| exhibit.article }
  end

  private
    def ordered_active_one_day_exhibited library_id, limit
      @relation.where(library_id: library_id).where("library_elements.exhibition_date IS NULL OR library_elements.exhibition_date >= ?", DateTime.now - 1.day).joins(:article).where(" articles.state = 'active' ").includes(:article => [:images,:seller]).order("library_elements.created_at ASC").limit limit
    end

    def set_exhibition_date_of library_element
      LibraryElement.find(library_element.id).update_attribute :exhibition_date, Time.now
    end
end