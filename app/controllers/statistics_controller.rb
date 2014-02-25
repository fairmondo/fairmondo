class StatisticsController < ApplicationController
  def general
    authorize Statistic.new
  end

  def category_sales
    authorize Statistic.new
  end
end
