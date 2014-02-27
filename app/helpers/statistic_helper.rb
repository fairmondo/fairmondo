module StatisticHelper
  def statistic_tr name,value,growth=nil
    render "statistic_tr", :name => name, :value => value, :growth => growth
  end
end
