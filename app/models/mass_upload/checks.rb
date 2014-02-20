# encoding: UTF-8
#
# == License:
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
module MassUpload::Checks
  extend ActiveSupport::Concern

  def self.get_csv_encoding path_to_csv
    match_euro_sign = File.new(path_to_csv, "r").getc
    case match_euro_sign
    when "\xDB"
      'MacRoman'
    when "\x80"
      'Windows-1252'
    when "\?"
      'IBM437'
    when "\xA4"
      'ISO-8859-15'
    else
      'utf-8'
    end
  end

end
