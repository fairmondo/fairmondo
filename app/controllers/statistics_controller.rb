#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class StatisticsController < ApplicationController
  def general
    @statistics = Statistic.new
    authorize @statistics
  end

  def category_sales
    @statistics = Statistic.new
    authorize @statistics
  end
end
