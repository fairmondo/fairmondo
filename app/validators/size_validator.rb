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
    if range.is_a?(Range)
      if value.size < range.first
        if range.first == 1
          add_error(record, attribute, error_message_for_at_least_one_entry)
        else
          add_error(record, attribute, error_message_for_minimum_entries)
        end
      end
      unless range.last == -1
        if value.size > range.last
          add_error(record, attribute, error_message_for_maximum_entries)
        end
      end
    else
      raise ArgumentError, "SizeValidator does not yet implement other argument types than Range"  
    end
  end  
  private
  
  def add_error(record, attribute, msg)
    attrs = options[:add_errors_to] || [attribute]
    attrs.each do |attr|
      record.errors[attr] << msg
    end
  end
  
  def error_message_for_at_least_one_entry
    (options[:messages] && options[:messages][:minimum_entries]) || I18n.t('errors.messages.at_least_one_entry')
  end
  
  def error_message_for_minimum_entries
    (options[:messages] && options[:messages][:minimum_entries]) || I18n.t('errors.messages.minimum_entries', :count => range.first)
  end
  
  def error_message_for_maximum_entries
    (options[:messages] && options[:messages][:maximum_entries]) || I18n.t('errors.messages.maximum_entries', :count => range.last)
  end
  
end