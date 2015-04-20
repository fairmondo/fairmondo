class BelboonArticleExporter
  @@csv_options = { col_sep: ';',  encoding: 'utf-8' }

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
    'Merchant_Product_Category' => nil,
    'Product_Description_Short' => nil,
    'Product_Description_Long' => 'Sanitize.clean(content)',
    'Last_Update' => 'updated_at',
    'Shipping' => nil,
    'Availability' => "'sofort lieferbar'",
    'Optional_1' => 'id',
    'Optional_2' => nil,
    'Optional_3' => nil,
    'Optional_4' => nil,
    'Optional_5' => nil
  }

  EXPORT_HEADER = %w(Merchant_ProductNumber EAN_Code Product_Title Manufacturer Brand Price Price_old Currency Valid_From Valid_To DeepLink_URL Into_Basket_URL Image_Small_URL Image_Small_HEIGHT Image_Small_WIDTH Image_Large_URL Image_Large_HEIGHT Image_Large_WIDTH Merchant_Product_Category Keywords Product_Description_Short Product_Description_Long Last_Update Shipping Availability Optional_1 Optional_2 Optional_3 Optional_4 Optional_5)

  FILE_NAME = Rails.env == 'development' ?
    "#{ Rails.root }/public/fairmondo_articles.csv" :
    '/var/www/fairnopoly/shared/public/system/fairmondo_articles.csv'

  class << self
    def export(user)
      CSV.open(FILE_NAME, 'wb', @@csv_options) do |line|
        line << EXPORT_HEADER

        exportable_articles_for(user).find_each do |article|
          line << line_for(article)
        end
      end
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
      user.articles.belboon_trackable.includes(:images)
    end
  end
end
