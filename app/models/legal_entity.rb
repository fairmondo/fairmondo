class LegalEntity < User
  attr_accessible :terms, :cancellation, :about
  
  validates_presence_of :terms
  validates_presence_of :cancellation
  validates_presence_of :about
  
end