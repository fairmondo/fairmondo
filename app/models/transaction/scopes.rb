module Transaction::Scopes
  extend ActiveSupport::Concern

  included do
    scope :sold, where("transactions.state = ? AND transactions.type != ?", "sold", "MultipleFixedPriceTransaction")
    scope :from_time, lambda { |start_time| where("transactions.sold_at > ? ",start_time) }
    scope :till_time, lambda { |end_time| where("transactions.sold_at < ? ",end_time) }
    scope :last_week, lambda { from_time(1.week.ago.beginning_of_week).till_time(DateTime.now.beginning_of_week) }
    scope :week_before_last_week, lambda { from_time(2.weeks.ago.beginning_of_week).till_time(1.week.ago.beginning_of_week) }
  end
end
