

class User < ActiveRecord::Base

  # lib dependency
  include SanitizeTinyMce
  
  # Friendly_id for beautiful links
  extend FriendlyId
  friendly_id :nickname, :use => :slugged
  validates_presence_of :slug

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :create_default_library

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
      :nickname, :forename, :surname, :image,:privacy, :legal, :agecheck, 
      :trustcommunity, :invitor_id, :banned, :about_me, 
      :title, :country, :street, :city, :zip, :phone, :mobile, :fax, 
      :terms, :cancellation, :about,  :recaptcha
  
  def self.attributes_protected_by_default
    # default is ["id","type"]
    ["id"]
  end
  
  attr_accessible :type 
  
  
  attr_protected :admin
      
  attr_accessor :recaptcha
  
  
  
  #Relations
  has_many :auctions, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_many :invitations, :dependent => :destroy

  has_many :auction_templates, :dependent => :destroy
  has_many :libraries, :dependent => :destroy

  has_attached_file :image, :styles => { :medium => "520x360>", :thumb => "260x180#" , :mini => "130x90#"}, :default_url => "missing.png" , :url => "/system/users/:attachment/:id_partition/:style/:filename", :path => "public/system/users/:attachment/:id_partition/:style/:filename"
  
  belongs_to :invitor ,:class_name => 'User', :foreign_key => 'invitor_id'
  
  
  # validations
  
  validates_inclusion_of :type, :in => ["PrivateUser","LegalEntity" ]
  
  validates_presence_of :forename , :on => :update
  validates_presence_of :surname , :on => :update
  validates_presence_of :title , :on => :update
  validates_presence_of :country , :on => :update
  validates_presence_of :street , :on => :update
  validates_presence_of :city , :on => :update
  
  validates_presence_of :recaptcha, :on => :create

  validates_presence_of :nickname
  
  validates :zip, :presence => true, :on => :update, :zip => true
  validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :image, :in => 0..5.megabytes
  
  validates :privacy, :acceptance => true, :on => :create
  validates :legal, :acceptance => true, :on => :create
  validates :agecheck, :acceptance => true , :on => :create
  
 
  
  def fullname
    fullname = "#{self.forename} #{self.surname}"
  end

  def display_name
    fullname
  end

  def name
    name = "#{self.nickname}"
  end

  def legal_entity_terms_ok
      if( self.valid?)
        return true
      else
        return false
      end
  end

  private 
  def create_default_library
    if self.libraries.empty?
      Library.create(:name => I18n.t('library.default'),:public => false, :user_id => self.id)
    end
  end



end
