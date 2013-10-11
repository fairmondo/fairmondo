#
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

  MAX_ARTICLES = 100

  def file_selected?
    if file
      return true
    else
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end
  end

  def csv_format?
    if file.content_type == "text/csv"
      return true
    else
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end
  end

  def open_csv
    @csv = []
    begin
      CSV.foreach(file.path, :encoding => 'utf-8', :col_sep => ";", :quote_char => '"', headers: true) do |row|
        @csv << row
      end
    rescue ArgumentError
      errors.add(:file, I18n.t('mass_upload.errors.wrong_encoding'))
      return false
    rescue CSV::MalformedCSVError
      errors.add(:file, I18n.t('mass_upload.errors.illegal_quoting'))
      return false
    end
    return true
  end

  def correct_article_count?
    if @csv.size <= MAX_ARTICLES
      return true
    else
      errors.add(:file, I18n.t('mass_upload.errors.wrong_file_size'))
      return false
    end
  end

  def correct_header?
    # bugbug header_row als hash (oder kommt es noch irgendwo auf die Reihenfolge an?)
    first_line = File.new(file.path, "r").gets
    csv_header = CSV.parse_line(first_line, :col_sep => ";")
    if csv_header == MassUpload.header_row
      return true
    else
      errors.add(:file, I18n.t('mass_upload.errors.wrong_header'))
      return false
    end
  end
end
