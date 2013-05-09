class LegalEntity < User

   before_validation :sanitize, :on => :create

  attr_accessible :terms, :cancellation, :about
  #
  # We cannot validate on user directly else resend password bzw. reset passwort does not work
  # if the user object doesnt validate and the user cannot reset his password!
  #
  # validates user
  validates_presence_of :forename , :on => :update
  validates_presence_of :surname , :on => :update
  validates_presence_of :title , :on => :update
  validates_presence_of :country , :on => :update
  validates_presence_of :street , :on => :update
  validates_presence_of :city , :on => :update
  validates_presence_of :zip , :on => :update
  # validates legal entity
  validates_presence_of :terms , :on => :update
  validates_presence_of :cancellation , :on => :update
  validates_presence_of :about , :on => :update

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end


  def sanitize
    self.about = sanitize_tiny_mce(self.about)
    self.cancellation = sanitize_tiny_mce(self.cancellation)
    self.terms = sanitize_tiny_mce(self.terms)
    self.about_me = sanitize_tiny_mce(self.about_me)
  end

end