#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FairTrustOtherValidator < ActiveModel::EachValidator
  # validates presence and length of value when 'Sonstiges' is selected in
  # fair trust questionnnaire
  def validate_each(record, attribute, value)
    if record.send("#{ attribute.to_s.chomp('_other') }_checkboxes").include? :other
      case
      when !value || value.length == 0
        record.errors[attribute] << I18n.t('active_record.error_messages.blank')
      when value.length < 5
        record.errors[attribute] << I18n.t('active_record.error_messages.too_short', count: 5)
      when value.length > 100
        record.errors[attribute] << I18n.t('active_record.error_messages.too_long', count: 100)
      end
    end
  end
end
