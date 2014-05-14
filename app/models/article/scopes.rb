module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope -> { where(article_template_id: nil).order('articles.created_at DESC') }

    scope :active, -> { where(state: :active) }
    scope :counting, -> { where("articles.state = 'active' OR articles.state = 'sold'") }
    scope :latest_without_closed, -> { where("state != 'closed'").order("created_at DESC").limit(1) }

  end
end
