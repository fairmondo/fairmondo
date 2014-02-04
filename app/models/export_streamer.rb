class ExportStreamer
  attr_reader :articles

  def initialize(user, params)
    @articles = determine_articles_to_export(user, params)
  end

  def each
    export_attributes = MassUpload.article_attributes
    transactions = false
    if articles.first.present? && articles.first.is_a?(Transaction)
      export_attributes += MassUpload.transaction_attributes
      transactions = true
    end
    options = {:col_sep => ";" }
    yield CSV.generate_line(export_attributes,options)

    articles.each do |item|
      article = item
      if transactions
        article = item.article
      end
      row = Hash.new
      row.merge!(article.provide_fair_attributes)
      row.merge!(article.attributes)
      row["categories"] = article.categories.map { |c| c.id }.join(",")
      row["external_title_image_url"] = article.images.first.external_url if article.images.first
      row["image_2_url"] = article.images[1].external_url if article.images[1]
      if transactions
        fee = article.calculated_fee_cents * item.quantity_bought
        donation = article.calculated_fair_cents * item.quantity_bought
        transaction_information = { "transport_provider" => item.selected_transport_provider,
                                    "sales_price_cents" => article.price_cents * item.quantity_bought,
                                    "price_without_vat_cents" => (article.price_without_vat.to_d * 100).to_i,
                                    "vat_cents" => (article.vat_price.to_d * 100).to_i,
                                    "shipping_and_handling_cents" => (item.article_transport_price(item.selected_transport, item.quantity_bought).to_d * 100).to_i,
                                    "buyer_email" => item.buyer_email,
                                    "fee_cents" => fee,
                                    "donation_cents" => donation,
                                    "total_fee_cents" => (fee + donation),
                                    "net_total_fee_cents" => ((fee + donation) / 1.19).round(0),
                                    "vat_total_fee_cents" => ((fee + donation) * 0.19).round(0)}
        row.merge!(transaction_information)
        buyer_information = item.attributes.slice(*MassUpload.transaction_attributes)
        row.merge!(buyer_information)
      end

      yield CSV.generate_line(export_attributes.map { |element| row[element] },options)


    end
  end

  def determine_articles_to_export(user, params)
    if params == "active"
      articles = user.articles.where(:state => "active")
    elsif params == "inactive"
      articles = user.articles.where(:state => "preview") + user.articles.where(:state => "locked")
    elsif params == "sold"
      articles = user.sold_transactions.joins(:article)
    elsif params == "bought"
      articles = user.bought_articles
    end
  end


end