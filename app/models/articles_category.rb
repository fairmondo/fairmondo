class ArticlesCategory < ActiveRecord::Base
  attr_accessible :article_id, :category_id

  belongs_to :article
  belongs_to :category

end
