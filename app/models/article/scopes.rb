module Article::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope -> { where.not(state: :template).order(created_at: :desc) }

    scope :active, -> { where(state: :active) }
    scope :counting, -> {
      where("articles.state = 'active' OR articles.state = 'sold'")
    }
    scope :latest_without_closed, -> {
      where.not(state: :closed).order(created_at: :desc).limit(1)
    }
    scope :reduced, -> {
      select('articles.state, articles.id, articles.title,
        articles.price_cents, articles.vat, articles.basic_price_cents,
        articles.basic_price_amount, articles.condition, articles.fair,
        articles.ecologic, articles.small_and_precious, articles.currency,
        articles.user_id, articles.slug, articles.borrowable,
        articles.swappable, articles.friendly_percent,
        articles.friendly_percent_organisation_id,
        articles.transport_bike_courier')
    }
  end
end
