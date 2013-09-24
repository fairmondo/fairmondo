module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope where(article_template_id: nil).order('created_at DESC')

    scope :active, where(state: :active)
    scope :counting, where("state = 'active' OR state = 'sold'")

    #scope :featured, find(::Settings.featured_article_id)

    def self.dreamteam_article
      begin
        if ::Settings.dream_team_article_id
          find(::Settings.dream_team_article_id)
        else
          nil
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
    def self.dreamteam_article2
      begin
        if ::Settings.dream_team_article2_id
          find(::Settings.dream_team_article2_id)
        else
          nil
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def self.newest_article
      begin
        if ::Settings.newest_article_id
          find(::Settings.newest_article_id)
        else
          nil
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
    def self.newest_article2
      begin
        if ::Settings.newest_article2_id
          find(::Settings.newest_article2_id)
        else
          nil
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def self.pioneer_article
      begin
        if ::Settings.pioneer_article_id
          find(::Settings.pioneer_article_id)
        else
          nil
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
    def self.pioneer_article2
      begin
        if ::Settings.pioneer_article2_id
          find(::Settings.pioneer_article2_id)
        else
          nil
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

  end
end
