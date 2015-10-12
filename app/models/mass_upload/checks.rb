#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module MassUpload::Checks
  extend ActiveSupport::Concern

  def self.get_csv_encoding path_to_csv
    match_euro_sign = File.new(path_to_csv, 'r').getc
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
