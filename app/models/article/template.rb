module Article::Template
  extend ActiveSupport::Concern

  included do

    attr_accessible :article_template_attributes
    # refs #128
    default_scope where(:article_template_id => nil)

    before_save :build_and_save_template, :if => :save_as_template?
    accepts_nested_attributes_for :article_template, :reject_if => proc {|attributes| attributes['save_as_template'] == "0" }

    before_validation :set_user_on_article_template , :if => :save_as_template?

  end

  def save_as_template?
    self.article_template && self.article_template.save_as_template == "1"
  end

  def set_user_on_article_template
    self.article_template.user = self.seller
  end

   # see #128
  def template?
    # Note:
    # * if not yet saved, there cannot be a article_template_id
    # * the inverse reference is set in article_template model before validation
    article_template_id != nil || article_template != nil
  end

    ########## build Template #################
  def build_and_save_template
    # Reown Template
    cloned_article = self.amoeba_dup
    cloned_article.article_template_id = self.article_template_id
    self.article_template_id = nil
    cloned_article.save #&& cloned_article.images.each { |image| image.save}
  end

end
