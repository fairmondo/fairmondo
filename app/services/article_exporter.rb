#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleExporter
  @@csv_options = { col_sep: ';',  encoding: 'utf-8' }
  @@export_attributes = MassUpload.article_attributes
  @@questionnaires = [:fair_trust, :social_producer]

  class << self
    def export(csv, user, params = nil)
      # write the headers and set options for csv generation
      csv.puts CSV.generate_line @@export_attributes, @@csv_options

      determine_articles_to_export(user, params).find_each do |article|
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
      if params == 'active'
        user.articles.where(state: 'active').order('created_at ASC')
          .includes(:images, :categories, :social_producer_questionnaire, :fair_trust_questionnaire)
      elsif params == 'inactive'
        user.articles.where('state = ? OR state = ?', 'preview', 'locked').order('created_at ASC')
          .includes(:images, :categories, :social_producer_questionnaire, :fair_trust_questionnaire)
      end
    end

    def create_row_for article
      row = {}
      @@questionnaires.each do |type|
        row.merge!(send("provide_#{ type }_attributes_for", article))
      end
      row.merge!(article.attributes)
      row['categories'] = categories_for article
      row['external_title_image_url'] = first_image_url_for article
      row['image_2_url'] = second_image_url_for article
      row
    end

    def categories_for article
      article.categories.map { |c| c.id }.join(',')
    end

    def first_image_url_for article
      article.images.first.external_url if article.images.first
    end

    def second_image_url_for article
      article.images[1].external_url if article.images[1]
    end

    def write_row_to_csv csv, row
      csv.puts CSV.generate_line @@export_attributes.map { |element| row[element] }, @@csv_options
    end

    @@questionnaires.each do |type|
      define_method "provide_#{ type }_attributes_for" do |article|
        attributes = {}
        if article.send("#{ type }_questionnaire")
          attributes.merge!(article.send("#{ type }_questionnaire").attributes)
        end
        serialize_checkboxes_in attributes
      end
    end

    def serialize_checkboxes_in attributes
      attributes.select { |k, _v| k.include?('checkboxes') }.each do |k, v|
        attributes[k] = v.any? ? v.join(',') : nil
      end
      attributes
    end
  end
end
