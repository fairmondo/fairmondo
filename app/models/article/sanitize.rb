module Article::Sanitize
  extend ActiveSupport::Concern

   # lib dependency
  include SanitizeTinyMce


  included do
    before_validation :sanitize_content, :on => :create

  end
  def sanitize_content
    self.content = sanitize_tiny_mce(self.content)
  end

end
