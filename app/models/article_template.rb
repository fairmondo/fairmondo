class ArticleTemplate < ActiveRecord::Base
  attr_accessible :article_attributes, :save_as_template, :name, :article

  validates :name, :uniqueness => {:scope => :user_id}
  validates :name, :presence => true
  validates :user_id, :presence => true

  attr_accessor :save_as_template

  belongs_to :user
  has_one :article, :dependent => :destroy

  validate :articles_article_template

  accepts_nested_attributes_for :article

  # refs #128 avoid default scope
  def article
    Article.unscoped{super}
  end

  def deep_article_attributes
    article_attributes = article.attributes
    nested_keys = article.nested_attributes_options.keys
    nested_keys.each do |key|
      relation = article.send(key)
      if relation.present?

        if relation.is_a?(Array) || relation.is_a?(ActiveRecord::Relation)
          if key == :images
            #ommit since we have to copy the images for new
          else
          # Commented. Currenty, article does not have has_many relations that accept nested attributes besides images! Images are c
          #  article_attributes["#{key}_attributes"] = []
          #  relation.each do |record|
          #    article_attributes["#{key}_attributes"] << record.attributes.except(*non_assignable_values)
          #  end


          end
        else

          article_attributes["#{key}_attributes"] = relation.attributes.except(*non_assignable_values)
        end
      end
    end
    article_attributes["category_ids"] = article.category_ids
    article_attributes
  end

  private

  def non_assignable_values
    ["id","created_at","updated_at","article_id"]
  end

  def articles_article_template
    # see https://github.com/rails/rails/issues/586:
    # work in progress - :before_add does not yet exist for has_one
    if article
      article.article_template ||= self
    else
      errors[:article] << I18n.t('active_record.error_messages.empty')
    end
  end

end
