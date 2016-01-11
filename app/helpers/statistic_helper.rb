#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module StatisticHelper
  def statistic_tr name, value, growth = nil
    render 'statistic_tr', name: name, value: value, growth: growth
  end
end
