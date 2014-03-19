module Tokenize
  extend Sanitization
  extend ActiveSupport::Concern

  def tokenizer_without_html
    lambda { |string| auto_sanitize(string).split(//) }
  end
end
