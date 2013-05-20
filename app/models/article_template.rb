class ArticleTemplate < ActiveRecord::Base
  
  attr_accessible :article_attributes, :name, :article,:save_as_template
  attr_accessor :save_as_template

  validates :name, :uniqueness => {:scope => :user_id}
  validates :name, :presence => true 
  validates :user_id, :presence => true

  belongs_to :user
  has_one :article, :dependent => :destroy
  
  accepts_nested_attributes_for :article

  # refs #128 avoid default scope
  def article
    Article.unscoped{super}
  end

  

  

end
