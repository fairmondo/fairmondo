class Exhibit < ActiveRecord::Base
  extend Enumerize

  def self.exhibit_attrs
    [:article, :queue, :related_article,:article_id,:related_article_id]
  end

  enumerize :queue, in: [:pioneer,:dream_team,:newest,:fairnopoly_likes,:fair_highlights,:ecologic_highlights,:small_and_precious_highlights]

  belongs_to :article
  belongs_to :related_article, class_name: "Article"

  def self.independent_queue queue, count = 2
    exhibits = Exhibit.where(:queue => queue).one_day_exhibited.article_active.oldest_first.limit count
    exhibits.each do |exhibit|
      exhibit.set_exhibition_date
    end
    exhibits.map{ |exhibit| exhibit.article}
  end

  def self.relation_queue queue
    articles = []
    exhibit = Exhibit.where(:queue => queue).one_day_exhibited.article_active.related_article_active.oldest_first.first
    if exhibit
      exhibit.set_exhibition_date
      articles << exhibit.article
      articles << exhibit.related_article
    end
    articles
  end

  def set_exhibition_date
    if self.exhibition_date == nil
       self.update_attribute(:exhibition_date,DateTime.now)
    end
  end

  scope :one_day_exhibited, lambda {where("exhibits.exhibition_date IS NULL OR exhibits.exhibition_date >= ?", DateTime.now - 1.day) }
  scope :oldest_first, order("exhibits.created_at ASC")

  scope :article_active, where(" articles.state = 'active' ").includes(:article => [:images,:seller])
  scope :related_article_active, where("related_articles_exhibits.state = 'active' ").includes(:related_article => [:images,:seller])

end
