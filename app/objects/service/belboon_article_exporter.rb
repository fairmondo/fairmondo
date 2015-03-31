class BelboonArticleExporter
  @@csv_options = { col_sep: ";",  encoding: 'utf-8' }

  EXPORT_MAPPING = {
    'Merchant_ProductNumber' => 'slug',
    'EAN_Code' => 'gtin',
    'Product_Title' => 'title',
    'Manufacturer' => nil,
    'Brand' => nil,
    'Price' => lambda { |article| Money.new(article.price_cents).to_s.gsub(',', '.') },
    'Price_old' => nil,
    'Currency' => "'EUR'",
    'Valid_From' => nil,
    'Valid_To' => nil,
    'DeepLink_URL' => lambda { |article| "https://www.fairmondo.de/articles/#{ article.slug }" },
    'Into_Basket_URL' => nil,
    'Image_Small_URL' => lambda { |article| thumb_image_path_for article },
    'Image_Small_HEIGHT' => "'200'",
    'Image_Small_WIDTH' => "'280'",
    'Image_Large_URL' => lambda { |article| medium_image_path_for article },
    'Image_Large_HEIGHT' => "'360'",
    'Image_Large_WIDTH' => "'520'",
    'Keywords' => nil,
    'Merchant_Product_Category' => nil,
    'Product_Description_Short' => nil,
    'Product_Description_Long' => 'content',
    'Last_Update' => 'updated_at',
    'Shipping' => nil,
    'Availability' => "'sofort lieferbar'",
    'Optional_1' => nil,
    'Optional_2' => nil,
    'Optional_3' => nil,
    'Optional_4' => nil,
    'Optional_5' => nil
  }

  EXPORT_HEADER = [
    'Merchant_ProductNumber', 'EAN_Code', 'Product_Title', 'Manufacturer',
    'Brand', 'Price', 'Price_old', 'Currency', 'Valid_From', 'Valid_To',
    'DeepLink_URL', 'Into_Basket_URL', 'Image_Small_URL', 'Image_Small_HEIGHT',
    'Image_Small_WIDTH', 'Image_Large_URL', 'Image_Large_HEIGHT', 'Image_Large_WIDTH',
    'Merchant_Product_Category', 'Keywords', 'Product_Description_Short',
    'Product_Description_Long', 'Last_Update', 'Shipping', 'Availability',
    'Optional_1', 'Optional_2', 'Optional_3', 'Optional_4', 'Optional_5'
  ]

  FILE_NAME = Rails.env == 'production' ? \
    '/var/www/fairnopoly/shared/public/fairmondo_articles.csv' : \
    "#{ Rails.root }/public/fairmondo_articles.csv"

  def self.export(user)
    CSV.open(FILE_NAME, 'wb', @@csv_options) do |line|
      line << EXPORT_HEADER

      export_articles(user).find_each do |article|
        line << line_for(article)
      end
    end

  end

  private

    def self.line_for article
      attrs = []
      EXPORT_HEADER.each do |attr|
        if !EXPORT_MAPPING[attr].present?
          attrs << EXPORT_MAPPING[attr]
        elsif article.respond_to? EXPORT_MAPPING[attr]
          attrs << "'#{ article.send(EXPORT_MAPPING[attr]) }'"
        elsif EXPORT_MAPPING[attr].class != String && EXPORT_MAPPING[attr].lambda?
          attrs << "'#{ EXPORT_MAPPING[attr].call(article) }'"
        else
          attrs << EXPORT_MAPPING[attr]
        end
      end
      attrs
    end

    def self.export_articles user
      user.articles.belboon_trackable.includes(:images)
    end

    def self.thumb_image_path_for article
      "https://www.fairmondo.de/#{ article.title_image_url :thumb }"
    end

    def self.medium_image_path_for article
      "https://www.fairmondo.de/#{ article.title_image_url :medium }"
    end
end
