class StatisticPolicy < Struct.new(:user, :statistic)

  def general?
    admin?
  end

  def category_sales?
    admin?
  end

  private
    def admin?
      user && user.admin?
    end
end