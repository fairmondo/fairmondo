class LibraryElement < ActiveRecord::Base

  attr_accessible :article, :library, :library_id, :article_id

  delegate :name, :user_id , :to => :library , :prefix => true
  delegate :title, :to => :article, :prefix => true
  # Validations

  validates :library_id, :uniqueness => {:scope => :article_id , :message => I18n.t('library_element.error.uniqueness') }

  validates :library_id , :presence => true

  # Relations

  belongs_to :article
  belongs_to :library

end
