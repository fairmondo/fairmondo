module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope -> { where.not(state: :template).order(created_at: :desc) }

    scope :active, -> { where(state: :active) }
    scope :counting, -> { where("articles.state = 'active' OR articles.state = 'sold'") }
    scope :latest_without_closed, -> { where.not(state: :closed).order(created_at: :desc).limit(1) }
  end
end
