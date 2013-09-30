module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope where(article_template_id: nil).order('created_at DESC')

    scope :active, where(state: :active)
    scope :counting, where("state = 'active' OR state = 'sold'")

  end
end
