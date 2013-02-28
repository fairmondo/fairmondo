class LegalEntity < User
  
  attr_accessible :terms, :cancellation, :about
  
  validates_presence_of :terms , :on => :update
  validates_presence_of :cancellation , :on => :update
  validates_presence_of :about , :on => :update
  
    # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
    def self.model_name
      User.model_name
    end
  
  def legal_entity_terms_ok
      if( self.terms && !self.terms.empty? &&
          self.cancellation && !self.cancellation.empty? &&
          self.about && !self.about.empty?)
        return true
      else
        return false
      end
  end
  
end