class BelboonArticleExporter
  @@csv_options = { col_sep: ";",  encoding: 'utf-8'}

  EXPORT_MAPPING = {
    'Merchant_ProductNumber' => 'slug',
    'EAN_Code' => 'gtin',
    'Product_Title' => 'title',
    'Manufacturer' => '',
    'Brand' => '',
    'Price' => 'price_cents',
    'Price_old' => '',
    'Currency' => '',
    'Valid_From' => '',
    'Valid_To' => '',
    'DeepLink_URL' => '',
    'Into_Basket_URL' => '',
    'Image_Small_URL' => '',
    'Image_Small_HEIGHT' => '',
    'Image_Small_WIDTH' => '',
    'Image_Large_URL' => '',
    'Image_Large_HEIGHT' => '',
    'Image_Large_WIDTH' => '',
    'Merchant_Product_Category' => '',
    'Keywords' => '',
    'Product_Description_Short' => '',
    'Product_Description_Long' => 'description',
    'Last_Update' => '',
    'Shipping' => '',
    'Availability' => '',
    'Optional_1' => '',
    'Optional_2' => '',
    'Optional_3' => '',
    'Optional_4' => '',
    'Optional_5' => ''
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

  def self.export(csv, user)
    csv.puts CSV.generate_line(EXPORT_HEADER, @@csv_options)

    csv.flush
  end
end
