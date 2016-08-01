#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BusinessTransactionExporter
  def initialize(user, time_range = nil)
    @user = user
    @time_range = time_range ? time_range : DateTime.new(2013, 6, 1)..DateTime.now
  end

  def csv_string
    CSV.generate(encoding: 'utf-8', col_sep: ';') do |csv|
      csv << ['Datum', 'Bestellnummer', 'Warenwert Bestellung (ohne UmSt.)',
              'Warenwert Bestellung (mit UmSt.)', 'Versandkosten Bestellung', 'Gesamtwert Bestellung',
              'Transaktionsnummer', 'Artikelname', 'Anzahl', 'Einzelkosten', 'Endbetrag',
              'Mehrwertsteuersatz', 'Versandart', 'Zahlungsart', 'Nachricht', 'Käufer',
              'Name', 'Firma', 'E-Mail-Adresse', 'Rechnungsadresse', 'Lieferadresse',
              'Storniert?', 'Stornierungsgrund']
      query.find_each do |bt|
        abacus = Abacus.new(bt.line_item_group)

        csv << [
          bt.line_item_group.sold_at.strftime('%d.%m.%Y'),
          bt.line_item_group.purchase_id,
          abacus.business_transaction_listing.total_net_price,
          abacus.business_transaction_listing.total_retail_price,
          abacus.transport_listing.total_transport,
          abacus.total,
          bt.id,
          bt.article.title,
          bt.quantity_bought,
          bt.article.price,
          bt.quantity_bought * bt.article.price,
          bt.article.vat,
          bt.selected_transport,
          bt.selected_payment,
          bt.line_item_group.message,
          bt.line_item_group.buyer.nickname,
          "#{bt.buyer.standard_address_first_name} #{bt.buyer.standard_address_last_name}",
          bt.buyer.standard_address_company_name,
          bt.line_item_group.buyer.email,
          bt.line_item_group.payment_address.to_s,
          bt.line_item_group.transport_address.to_s,
          bt.refund.present?,
          bt.refund.present? ? bt.refund.reason : ''
        ]
      end
    end
  end

  def query
    BusinessTransaction
      .joins('LEFT OUTER JOIN refunds ON refunds.business_transaction_id = business_transactions.id')
      .joins(:article, line_item_group: [:payment_address, :transport_address, :buyer])
      .where(line_item_groups: { seller_id: @user.id }, sold_at: @time_range)
  end

  def filename
    start_date = @time_range.begin.strftime('%Y%m%d')
    end_date = @time_range.end.strftime('%Y%m%d')
    "fairmondo-bestellungen_#{start_date}-#{end_date}.csv"
  end
end
