# refs #198
class ZipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    case record.country
      when "Deutschland"
        length=5
        if value.length != length
          record.errors[attribute] << I18n.t('devise.edit_profile.error_zip_length', :count => length)
        end
        unless only_numbers?(value)
          record.errors[attribute] << I18n.t('devise.edit_profile.error_zip_format')
        end
    end
  end
  
  private
  
  def only_numbers?(value)
    if value.match(/^\d*$/)
      true
    else
      false
    end
  end
  
end
