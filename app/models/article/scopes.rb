module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope where(article_template_id: nil).order('created_at DESC')

    scope :active, where(state: :active)
    scope :active_old,where(state: :active_old)

    #scope :featured, find(::Settings.featured_article_id)
    def self.featured
      find(::Settings.featured_article_id)
    end
  end
end
