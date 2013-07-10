#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
# refs #198
class ZipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    case record.country
      when "Deutschland"
        length=5
        if value.to_s.length != length
          record.errors[attribute] << I18n.t('errors.messages.zip_length', :count => length)
        end
        unless only_numbers?(value)
          record.errors[attribute] << I18n.t('errors.messages.zip_format')
        end
    end
  end

  private

  def only_numbers?(value)
    value.to_s.match(/^\d*$/)
  end

end
