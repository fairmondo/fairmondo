#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module ArticleConcerns
  module Scopes
    extend ActiveSupport::Concern

    included do
      default_scope { where.not(state: :template).order(created_at: :desc) }

      scope :active, -> { where(state: :active) }
      scope :not_closed, -> { where.not(state: :closed) }
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

      scope :belboon_trackable, -> {
        where('state = ? AND
              condition = ? AND
              fair = ? AND
              ecologic = ? AND
              small_and_precious = ?',
              'active', 'new', false, false, false)
      }

      scope :units_placed_for_categories, -> (categories) {
        joins(:articles_categories)
          .where(articles: { state: 'active' }, articles_categories: { category_id: categories })
          .sum(:quantity)
      }

      scope :units_sold_for_categories, -> (categories, time_range) {
        joins(:articles_categories, :business_transactions)
          .where(articles_categories: { category_id: categories },
                business_transactions: { created_at: time_range })
          .sum(:quantity_bought)
      }
    end
  end
end
