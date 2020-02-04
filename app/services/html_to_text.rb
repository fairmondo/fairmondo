#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class HtmlToText
  def self.convert html
    premailer = Premailer.new html, with_html_string: true, line_length: 10000000000
    premailer.to_plain_text
  end
end
