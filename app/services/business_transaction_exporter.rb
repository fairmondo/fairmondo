#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BusinessTransactionExporter
  def initialize(user, time_range = nil)
    @user = user
    @time_range = time_range ? time_range : DateTime.new(2013, 6, 1)..DateTime.now
  end

  def filename
    start_date = @time_range.begin.strftime('%Y%m%d')
    end_date = @time_range.end.strftime('%Y%m%d')
    "fairmondo-bestellungen_#{start_date}-#{end_date}.csv"
  end

  def csv_string
    CSV.generate(encoding: 'utf-8', col_sep: ';') do |csv|
      csv << csv_headers

      query.find_each do |bt|
        row = (line_item_group_fields(bt.line_item_group) + business_transaction_fields(bt))
        update_row_if_unified_transport(row, bt.line_item_group)
        csv << row
      end
    end
  end

  def csv_headers
    %w(
      Datum Bestellnummer Bestellwert\ netto\ ohne\ Versand
      Bestellwert\ brutto\ ohne\ Versand Versandkosten\ Bestellung Gesamtwert\ Bestellung
      Nachricht Käufer Name Firma E-Mail-Adresse Rechnungsadresse Lieferadresse
      Transaktionsnummer Artikelname Anzahl Einzelkosten Endbetrag Mehrwertsteuersatz Versandart
      Zahlungsart Storniert? Stornierungsgrund
    )
  end

  def query
    BusinessTransaction
      .joins('LEFT OUTER JOIN refunds ON refunds.business_transaction_id = business_transactions.id')
      .joins(:article, line_item_group: [:payment_address, :transport_address, :buyer])
      .where(line_item_groups: { seller_id: @user.id }, sold_at: @time_range)
  end

  def line_item_group_fields(lig)
    abacus = Abacus.new(lig)

    [
      lig.sold_at.strftime('%d.%m.%Y'),
      lig.purchase_id,
      abacus.business_transaction_listing.total_net_price,
      abacus.business_transaction_listing.total_retail_price,
      abacus.transport_listing.total_transport,
      abacus.total,
      lig.message,
      lig.buyer.nickname,
      "#{lig.buyer.standard_address_first_name} #{lig.buyer.standard_address_last_name}",
      lig.buyer.standard_address_company_name,
      lig.buyer.email,
      lig.payment_address.to_s,
      lig.transport_address.to_s
    ]
  end

  def business_transaction_fields(bt)
    transport = bt.selected_transport
    if (transport == 'type1')
      transport = bt.article.transport_type1_provider
    elsif (transport == 'type2')
      transport = bt.article.transport_type2_provider
    end

    [
      bt.id,
      bt.article.title,
      bt.quantity_bought,
      bt.article.price,
      bt.quantity_bought * bt.article.price,
      bt.article.vat,
      transport,
      bt.selected_payment,
      bt.refund.present? ? 'ja' : 'nein',
      bt.refund.present? ? bt.refund.reason : nil
    ]
  end

  def update_row_if_unified_transport(row, lig)
    if lig.unified_transport
      row[19] = lig.unified_transport_provider
    end

    if lig.unified_payment
      row[20] = lig.unified_payment_method
    end
  end
end
