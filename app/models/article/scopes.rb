module Article::Scopes
  extend ActiveSupport::Concern

  included do
    #scope :featured, find(::Settings.featured_article_id)
    def self.featured
      find(::Settings.featured_article_id)
    end
  end
end
