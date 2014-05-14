class ArticleExporter

  @@csv_options = { col_sep: ";" }

  def self.export( csv, user, params = nil )

    # Generate proper headers and find out if we are messing with transactions
    export_attributes = MassUpload.article_attributes
    export_attributes += MassUpload.business_transaction_attributes if params == "sold"

    #write the headers and set options for csv generation
    csv.puts CSV.generate_line export_attributes, @@csv_options


    determine_articles_to_export( user, params ).find_each do |item|

      article = item.is_a?( BusinessTransaction ) ? item.article : item

      row = Hash.new
      row.merge!(provide_fair_attributes_for article)
      row.merge!(article.attributes)
      row["categories"] = article.categories.map { |c| c.id }.join(",")
      row["external_title_image_url"] = article.images.first.external_url if article.images.first
      row["image_2_url"] = article.images[1].external_url if article.images[1]
      if item.is_a? BusinessTransaction
        fee = article.calculated_fee_cents * item.quantity_bought
        donation = article.calculated_fair_cents * item.quantity_bought
        transaction_attrs = { "transport_provider" => item.selected_transport_provider,
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
        row.merge!(transaction_attrs)
        buyer_information = item.attributes.slice(*MassUpload.business_transaction_attributes)
        row.merge!(buyer_information)
      end
      csv.puts CSV.generate_line export_attributes.map { |element| row[element] }, @@csv_options

    end
    csv.flush
  end


  def self.export_erroneous_articles erroneous_articles
    csv = CSV.generate_line( MassUpload.article_attributes, @@csv_options )
    erroneous_articles.each do |article|
      csv += article.article_csv
    end
    csv
  end


  def self.determine_articles_to_export user, params
    if params == "active"
      user.articles.where(:state => "active").order("created_at ASC").includes(:images,:categories,:social_producer_questionnaire,:fair_trust_questionnaire)
    elsif params == "inactive"
      user.articles.where("state = ? OR state = ?","preview","locked").order("created_at ASC").includes(:images,:categories,:social_producer_questionnaire,:fair_trust_questionnaire)
    elsif params == "sold"
      user.sold_business_transactions.joins(:article)
    elsif params == "bought"
      user.bought_articles
    end
  end


  def self.provide_fair_attributes_for article
    attributes = Hash.new
    if article.fair_trust_questionnaire
      attributes.merge!(article.fair_trust_questionnaire.attributes)
    end

    if article.social_producer_questionnaire
      attributes.merge!(article.social_producer_questionnaire.attributes)
    end
    serialize_checkboxes_in attributes
  end


  def self.serialize_checkboxes_in attributes
    attributes.each do |k, v|
      if k.include?("checkboxes")
        if v.any?
          attributes[k] = v.join(',')
        else
          attributes[k] = nil
        end
      end
    end
    attributes
  end

end
