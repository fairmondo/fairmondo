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
      result[:fair]= Money.new(0)
      result[:fair_quantity]= Money.new(0)

     Article.active.each do |article|
       result[:sum] += article.price
       result[:sum_quantity] += (article.price * article.quantity)
       result[:provision] += article.calculated_fee
       result[:provision_quantity] += (article.calculated_fee * article.quantity)
       result[:fair] += article.calculated_fair
       result[:fair_quantity] += (article.calculated_fair * article.quantity)
     end

     count_fair = Article.active.where(:fair => true).count
     count_eco = Article.active.where(:ecologic => true).count
     count_total =  Article.active.count
     result[:fair_part] =  count_fair*1.0 / (count_total==0 ? 1 : count_total)
     result[:eco_part] =  count_eco*1.0 / (count_total==0 ? 1 : count_total)
     result
  end



end
