#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BusinessTransactionExporter
  def initialize(user)
    @user = user
  end

  def export
    []
  end

  def csv_string
    csv_string = CSV.generate(encoding: 'UTF-8') do |csv|
      csv << ['Datum', 'Bestellnr.', 'Anzahl']
      query.each do |bt|
        csv << [
          bt.sold_at,
          bt.line_item_group_id,
          bt.quantity_bought
        ]
      end
    end
  end

  def query
    BusinessTransaction.joins(:line_item_group).where(line_item_groups: { seller_id: @user.id })
  end
end
