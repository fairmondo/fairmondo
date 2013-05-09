class RemoveIndexJob < Struct.new(:options)
  def perform
    return if options.nil?
    options.symbolize_keys!
    record = options[:record_class].constantize.new
    options[:attributes].except("id").each do |k,v|
      record[k] = v
    end
    record.id = options[:attributes]["id"]
    record.remove_from_index_without_delayed
  end
end