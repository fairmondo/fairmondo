module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope where(article_template_id: nil)

    #scope :featured, find(::Settings.featured_article_id)
    def self.featured
      find(::Settings.featured_article_id)
    end
  end
end
