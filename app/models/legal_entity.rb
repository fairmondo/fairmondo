class LegalEntity < User
  
  attr_accessible :terms, :cancellation, :about
  
  # validates
  validates_presence_of :forename , :on => :update
  validates_presence_of :surname , :on => :update
  validates_presence_of :title , :on => :update
  validates_presence_of :country , :on => :update
  validates_presence_of :street , :on => :update
  validates_presence_of :city , :on => :update
  validates_presence_of :zip , :on => :update
  
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