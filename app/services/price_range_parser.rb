#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PriceRangeParser
  def initialize from, to
    @empty = from.blank? && to.blank?
    @from_money = Monetize.parse(from)
    @to_money = Monetize.parse(to)
  end

  def from
    @from_money.format unless @empty
  end

  def from_cents
    @from_money.cents unless @empty
  end

  def to
    @to_money.format if show_to?
  end

  def to_cents
    @to_money.cents if show_to?
  end

  def form_values
    [from, to]
  end

  def formated_prices
    if from.present? && to.present?
      "#{from}–#{to}"
    elsif from.present? && to.blank?
      "> #{from}"
    else
      nil
    end
  end

  private

  def show_to?
    !@empty && @to_money.cents >= 0 && @to_money >= @from_money
  end
end
