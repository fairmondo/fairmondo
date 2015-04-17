module Tokenize
  extend Sanitization
  extend ActiveSupport::Concern

  def tokenizer_without_html
    -> (string) { auto_sanitize(string).first.split(//) }
  end
end
