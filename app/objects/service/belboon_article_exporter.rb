#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BelboonArticleExporter
  @@csv_options = { col_sep: ';',  encoding: 'utf-8' }

  MAX_LINE_COUNT = 500_000

  EXPORT_MAPPING = {
    'Merchant_ProductNumber' => 'slug',
    'EAN_Code' => 'gtin',
    'Product_Title' => 'title',
    'Manufacturer' => nil,
    'Brand' => nil,
    'Price' => "Money.new(self.price_cents).to_s.gsub(',', '.')",
    'Price_old' => nil,
    'Currency' => "'EUR'",
    'Valid_From' => nil,
    'Valid_To' => nil,
    'DeepLink_URL' => "'https://www.fairmondo.de/articles/' + slug",
    'Into_Basket_URL' => nil,
    'Image_Small_URL' => "'https://www.fairmondo.de/' + title_image_url(:thumb)",
    'Image_Small_HEIGHT' => "'200'",
    'Image_Small_WIDTH' => "'280'",
    'Image_Large_URL' => "'https://www.fairmondo.de/' + title_image_url(:medium)",
    'Image_Large_HEIGHT' => nil,
    'Image_Large_WIDTH' => nil,
    'Keywords' => nil,
    'Merchant_Product_Category' => "self.categories.first.self_and_ancestors.map(&:name).join(' > ')",
    'Product_Description_Short' => nil,
    'Product_Description_Long' => 'Sanitize.clean(content)',
    'Last_Update' => "self.updated_at.strftime('%d-%m-%Y')",
    'Shipping' => "Money.new(self.transport_type1_price_cents).to_s.gsub(',', '.')",
    'Availability' => "'sofort lieferbar'",
    'Optional_1' => 'id',
    'Optional_2' => nil,
    'Optional_3' => nil,
    'Optional_4' => nil,
    'Optional_5' => nil
  }

  EXPORT_HEADER = %w(Merchant_ProductNumber EAN_Code Product_Title Manufacturer Brand Price Price_old Currency Valid_From Valid_To DeepLink_URL Into_Basket_URL Image_Small_URL Image_Small_HEIGHT Image_Small_WIDTH Image_Large_URL Image_Large_HEIGHT Image_Large_WIDTH Merchant_Product_Category Keywords Product_Description_Short Product_Description_Long Last_Update Shipping Availability Optional_1 Optional_2 Optional_3 Optional_4 Optional_5)

  FILE_NAME = Rails.env == 'development' ?
    "#{ Rails.root }/public/fairmondo_articles_" :
    '/var/www/fairnopoly/shared/public/system/fairmondo_articles_'

  class << self
    def export
      line_count = 0
      file_count = 0

      csv = new_csv_file(file_count)

      BELBOON_IDS.each do |id|
        user = User.find id
        exportable_articles_for(user).find_each do |article|
          if line_count >= MAX_LINE_COUNT
            file_count += 1
            line_count = 0
            csv.close
            csv = new_csv_file(file_count)
          end

          csv << line_for(article)
          line_count += 1
        end
      end
      csv.close
    end

    def new_csv_file file_count
      csv = CSV.open("#{ FILE_NAME }#{ file_count }.csv", 'wb', @@csv_options)
      csv.sync = true
      csv << EXPORT_HEADER
      csv
    end

    def line_for article
      attrs = []
      EXPORT_HEADER.each do |attr|
        begin
          attrs << "'#{ article.instance_eval(EXPORT_MAPPING[attr]) }'"
        rescue
          attrs << "'#{ EXPORT_MAPPING[attr] }'"
        end
      end
      attrs
    end

    def exportable_articles_for user
      user.articles.belboon_trackable.includes([:images, :categories])
    end
  end
end
