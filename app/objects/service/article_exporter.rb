class ArticleExporter
  @@csv_options = { col_sep: ";",  encoding: 'utf-8' }
  @@export_attributes = MassUpload.article_attributes

  class << self
    def export( csv, user, params = nil )
      #write the headers and set options for csv generation
      csv.puts CSV.generate_line @@export_attributes, @@csv_options

      determine_articles_to_export( user, params ).find_each do |article|
        row = create_row_for article
        write_row_to_csv csv, row
      end
      csv.flush
    end

    def export_erroneous_articles erroneous_articles
      csv = CSV.generate_line(@@export_attributes, @@csv_options)
      erroneous_articles.each do |article|
        csv += article.article_csv
      end
      csv
    end

    private
      def determine_articles_to_export user, params
        if params == "active"
          user.articles.where(:state => "active").order("created_at ASC")
            .includes(:images, :categories, :social_producer_questionnaire, :fair_trust_questionnaire)
        elsif params == "inactive"
          user.articles.where("state = ? OR state = ?","preview","locked").order("created_at ASC")
            .includes(:images, :categories, :social_producer_questionnaire, :fair_trust_questionnaire)
        end
      end

      def create_row_for article
        row = Hash.new
        row.merge!(provide_fair_attributes_for article)
        row.merge!(provide_social_attributes_for article)
        row.merge!(article.attributes)
        row["categories"] = article.categories.map { |c| c.id }.join(",")
        row["external_title_image_url"] = article.images.first.external_url if article.images.first
        row["image_2_url"] = article.images[1].external_url if article.images[1]
        row
      end

      def write_row_to_csv csv, row
        csv.puts CSV.generate_line @@export_attributes.map { |element| row[element] }, @@csv_options
      end

      def provide_fair_attributes_for article
        attributes = Hash.new
        if article.fair_trust_questionnaire
          attributes.merge!(article.fair_trust_questionnaire.attributes)
        end
        serialize_checkboxes_in attributes
      end

      def provide_social_attributes_for article
        attributes = Hash.new
        if article.social_producer_questionnaire
          attributes.merge!(article.social_producer_questionnaire.attributes)
        end
        serialize_checkboxes_in attributes
      end

      def serialize_checkboxes_in attributes
        attributes.select{ |k, _v| k.include?('checkboxes') }.each do |k, v|
          attributes[k] = v.any? ? v.join(',') : nil
        end
        attributes
      end
  end
end
