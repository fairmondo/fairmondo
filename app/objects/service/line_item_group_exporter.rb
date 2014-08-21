
class LineItemGroupExporter

  @@csv_options = { col_sep: ";",  encoding: 'utf-8'}

# methods for exporting line_item_group articles with corresponding fields of
  # line_item_group, business_transaction
  def self.export(csv, user, params)
    csv.puts(CSV.generate_line(export_attrs, @@csv_options))

    get_line_item_groups(user, params).find_each do |lig|
      lig.business_transactions.find_each do |bt|
        row = Hash.new
        [lig, bt, bt.article].each do |item|
          attrs = Hash[item.attributes.map {|k, v| [export_mappings(item)[k], v] }]
          row.merge!(attrs.select { |k, v| export_attrs.include?(k) })
        end
        csv.puts(CSV.generate_line(export_attrs.map { |element| row[element] }, @@csv_options))
      end
    end
    csv.flush
  end

  def self.get_line_item_groups(user, params)
    if params[:time_range] && params[:time_range] != 'all'
      user.seller_line_item_groups.where('created_at > ? AND created_at < ?', params[:time_range].to_i.month.ago, Time.now).includes(:buyer, business_transactions: [:article])
    else
      user.seller_line_item_groups
    end
  end

  # Maps attributes of a model to attribute name prefixed with model name
  def self.export_mappings(item)
    hash = {}
    item.class.column_names.each { |column_name| hash[column_name] = "#{mapping_name[item.class.name]}_#{column_name}"}
    return hash
  end

  # used to prefix model attributes in csv with user friendly name instead of model name
  def self.mapping_name
    {
      'Article' => 'article',
      'BusinessTransaction' => 'transaction',
      'LineItemGroup' => 'purchase',
      'User' => 'buyer',
      'Address' => 'address'
    }
  end

  # used to determine which columns of line_item_groups and business_transactions and articles should be exported
  # TODO consider which attributes should be exported and write them to the array
  def self.export_attrs
    [
      'purchase_id', 'purchase_created_at', 'transaction_id',
      'transaction_quantity_bought', 'article_id', 'article_title',
      'article_custom_seller_identifier'
    ]
  end

end