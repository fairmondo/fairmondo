# refs #153
class SizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    range = options[:in]
    value ||= []
    value = [value] unless value.respond_to?(:size) # fix for existing entries
    unless options[:allow_blank_entries]
      value = value.select(&:present?)
    end
    
    if options[:filter]
      value = options[:filter].call(value) 
    end
    
    if value.size < range.first
      msg_key = range.first == 1 ? :at_least_one : :minimum
      add_error(record, attribute, msg_key, range.first)
    end
    unless range.last == -1
      if value.size > range.last
        add_error(record, attribute, :maximum, range.last)
      end
    end
  end
  
  private
  
  def add_error(record, attribute, msg_key, count)
    if msg_key == :at_least_one
      default = ["minimum_#{attribute}".to_sym, "#{msg_key}_entry".to_sym, :minimum_entries]
    else
      default = "#{msg_key}_entries".to_sym
    end
    
    msg = I18n.t("#{msg_key}_#{attribute}", 
        :default => default, :scope => ["errors.messages"], :count => count)
    
    attrs = options[:add_errors_to] || [attribute]
    attrs.each do |attr|
      record.errors[attr] << msg
    end
  end
  
end