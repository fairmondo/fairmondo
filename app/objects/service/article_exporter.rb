class ArticleExporter

  @@csv_options = { col_sep: ";",  encoding: 'utf-8'}

  def self.export( csv, user, params = nil )

    # Generate proper headers and find out if we are messing with transactions
    export_attributes = MassUpload.article_attributes

    #write the headers and set options for csv generation
    csv.puts CSV.generate_line export_attributes, @@csv_options


    determine_articles_to_export( user, params ).find_each do |article|

      row = Hash.new
      row.merge!(provide_fair_attributes_for article)
      row.merge!(article.attributes)
      row["categories"] = article.categories.map { |c| c.id }.join(",")
      row["external_title_image_url"] = article.images.first.external_url if article.images.first
      row["image_2_url"] = article.images[1].external_url if article.images[1]
      csv.puts CSV.generate_line export_attributes.map { |element| row[element] }, @@csv_options

    end
    csv.flush
  end


  def self.export_line_item_groups(csv, user)
    export_attributes = LineItemGroup.exportable_attributes

    csv.puts(CSV.generate_line(export_attributes, @@csv_options))

    user.seller_line_item_groups.find_each do |lig|
      lig.business_transactions.find_each do |bt|
        row = Hash.new
        [lig, bt, bt.article].each do |item|
          part = item.attributes.select { |k, v| item.export_attrs.include?(k) }
          row.merge!(Hash[part.map {|k, v| [item.class.export_mappings[k], v] }])
        end
        csv.puts(CSV.generate_line(export_attributes.map { |element| row[element] }, @@csv_options))
      end
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
