class LegalEntity < User
  
  attr_accessible :terms, :cancellation, :about
  
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