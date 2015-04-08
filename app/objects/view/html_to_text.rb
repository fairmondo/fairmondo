class HtmlToText
  def self.convert html
    premailer = Premailer.new html, with_html_string: true, line_length: 10000000000
    premailer.to_plain_text
  end
end
