#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
# refs #153
class SizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    range = options[:in]
    value ||= []
    value = [value] unless value.respond_to?(:size) # fix for existing entries
    unless options[:allow_blank_entries]
      value = value.select(&:present?)
    end

    # if options[:filter]
    #   value = options[:filter].call(value)
    # end

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
