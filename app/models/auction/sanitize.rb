module Auction::Sanitize
  extend ActiveSupport::Concern
  
  included do
    before_validation :sanitize_content, :on => :create
  end
  
  private

  def sanitize_content
    self.content = sanitize_tiny_mce(self.content)
  end

  def sanitize_tiny_mce(field)
    ActionController::Base.helpers.sanitize(field,
    :tags => %w(a b i strong em p param h1 h2 h3 h4 h5 h6 br hr ul li img),
    :attributes => %w(href name src type value width height data style) );
  end
  
end