class FairTrustOtherValidator < ActiveModel::EachValidator
  # validates presence and length of value when 'Sonstiges' is selected in
  # fair trust questionnnaire
  def validate_each(record, attribute, value)
    if record.send("#{attribute.to_s.chomp('_other')}_checkboxes").include? :other
      if value
        if value.length == 0
          record.errors[attribute] << I18n.t('active_record.error_messages.blank')
        end

        if value.length < 5
          record.errors[attribute] << I18n.t('active_record.error_messages.too_short', count: 5)
        end

        if value.length > 100
          record.errors[attribute] << I18n.t('active_record.error_messages.too_long', count: 100)
        end
      else
        record.errors[attribute] << I18n.t('active_record.error_messages.blank')
      end
    end
  end
end
