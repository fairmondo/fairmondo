class LibraryElement < ActiveRecord::Base

  attr_accessible :auction, :library, :library_id, :auction_id

  # Validations

  validates :library_id, :uniqueness => {:scope => :auction_id , :message => I18n.t('library_element.error.uniqueness') }

  validates :library_id , :presence => true

  # Relations

  belongs_to :auction
  belongs_to :library

end
