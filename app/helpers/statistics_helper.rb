#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module StatisticsHelper

  def statistics_category c
    a = Article.new(:categories_and_ancestors => [c])
    articles = a.find_like_this(1)
    articles.total
  rescue
    0
  end

  def statistics_articles
    result = {}
    result[:sum]= Money.new(0)
    result[:sum_quantity]= Money.new(0)
    result[:provision]= Money.new(0)
    result[:provision_quantity]= Money.new(0)
    result[:provision_by_fair]= Money.new(0)
    result[:provision_by_fair_quantity]= Money.new(0)
    result[:provision_by_conventional]= Money.new(0)
    result[:provision_by_conventional_quantity]= Money.new(0)
    result[:fair]= Money.new(0)
    result[:fair_quantity]= Money.new(0)

    Article.active.each do |article|
      result[:sum] += article.price
      result[:sum_quantity] += (article.price * article.quantity)
      result[:provision] += article.calculated_fee
      result[:provision_quantity] += (article.calculated_fee * article.quantity)
      result[:fair] += article.calculated_fair
      result[:fair_quantity] += (article.calculated_fair * article.quantity)

      if article.fair?
        result[:provision_by_fair] += article.calculated_fee
        result[:provision_by_fair_quantity] += ( article.calculated_fee * article.quantity )
      else
        result[:provision_by_conventional] += article.calculated_fee
        result[:provision_by_conventional_quantity] += ( article.calculated_fee * article.quantity )
      end
    end

    count_fair = Article.active.where(:fair => true).count
    count_eco = Article.active.where(:ecologic => true).count
    count_total =  Article.active.count
    result[:fair_part] =  count_fair*1.0 / (count_total==0 ? 1 : count_total)
    result[:eco_part] =  count_eco*1.0 / (count_total==0 ? 1 : count_total)
    result
  end

  def statistics_sold_articles
    result_sold = {}
    result_sold[:amount_unique] = 0
    result_sold[:amount_total] = 0
    result_sold[:sold_value]= Money.new(0)
    result_sold[:sold_fee]= Money.new(0)
    result_sold[:sold_fair]= Money.new(0)

    Transaction.joins(:article).includes(:article).where("transactions.state = ? AND transactions.sold_at > ?", :sold, Time.parse("2013-09-23 23:25:00.000000 +02:00")).find_each do |transaction|
      result_sold[:amount_unique] += 1
      result_sold[:amount_total] += transaction.quantity_bought
      result_sold[:sold_value] += transaction.article_price * transaction.quantity_bought
      result_sold[:sold_fee] += transaction.article.calculated_fee * transaction.quantity_bought
      result_sold[:sold_fair] += transaction.article.calculated_fair * transaction.quantity_bought
    end
    result_sold
  end

  def weekly_statistics_sold_articles
    weekly_result_sold = {}
    weekly_result_sold[:amount_unique] = 0
    weekly_result_sold[:amount_total] = 0
    weekly_result_sold[:sold_value]= Money.new(0)
    weekly_result_sold[:sold_fee]= Money.new(0)
    weekly_result_sold[:sold_fair]= Money.new(0)

    # TODO Would a join like in line 76 bring any benefits?
    Transaction.where("state = ? AND sold_at > ? AND sold_at < ?",
      :sold, monday_one_week_ago, last_monday)
    .find_each do |transaction|
      weekly_result_sold[:amount_unique] += 1
      weekly_result_sold[:amount_total] += transaction.quantity_bought
      weekly_result_sold[:sold_value] += transaction.article_price * transaction.quantity_bought
      weekly_result_sold[:sold_fee] += transaction.article.calculated_fee * transaction.quantity_bought
      weekly_result_sold[:sold_fair] += transaction.article.calculated_fair * transaction.quantity_bought
    end
    weekly_result_sold
  end

  def biweekly_statistics_sold_articles
    biweekly_result_sold = {}
    biweekly_result_sold[:amount_unique] = 0
    biweekly_result_sold[:amount_total] = 0
    biweekly_result_sold[:sold_value]= Money.new(0)
    biweekly_result_sold[:sold_fee]= Money.new(0)
    biweekly_result_sold[:sold_fair]= Money.new(0)

    Transaction.where(
      "state = ? AND sold_at > ? AND sold_at < ?",
      :sold, monday_two_weeks_ago, monday_one_week_ago)
    .find_each do |transaction|
      biweekly_result_sold[:amount_unique] += 1
      biweekly_result_sold[:amount_total] += transaction.quantity_bought
      biweekly_result_sold[:sold_value] += transaction.article_price * transaction.quantity_bought
      biweekly_result_sold[:sold_fee] += transaction.article.calculated_fee * transaction.quantity_bought
      biweekly_result_sold[:sold_fair] += transaction.article.calculated_fair * transaction.quantity_bought
    end
    biweekly_result_sold
  end

  def last_monday
    Time.new.beginning_of_week
  end

  def monday_one_week_ago
    Time.new.beginning_of_week - 1.week
  end

  def monday_two_weeks_ago
    Time.new.beginning_of_week - 2.weeks
  end
end
