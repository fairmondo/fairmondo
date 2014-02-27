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
