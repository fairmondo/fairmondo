module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope where(article_template_id: nil).order('created_at DESC')

    scope :active, where(state: :active)
    scope :active_old,where(state: :active_old)

    #scope :featured, find(::Settings.featured_article_id)

    def self.dreamteam
      if ::Settings.dream_team_article_id
        find(::Settings.dream_team_article_id)
      else
        nil
      end
    end
    def self.dreamteam2
      if ::Settings.dream_team_article2_id
        find(::Settings.dream_team_article2_id)
      else
        nil
      end
    end

  end
end
