module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope where(article_template_id: nil).order('created_at DESC')

    scope :active, where(state: :active)
    scope :active_old,where(state: :active_old)

    #scope :featured, find(::Settings.featured_article_id)

    def self.dream_team
      find(::Settings.dream_team_article_id)
    end
    def self.dream_team2
      find(::Settings.dream_team_article2_id)
    end

  end
end
