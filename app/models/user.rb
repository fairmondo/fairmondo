class User < ActiveRecord::Base

  #set defaults before saving
  #before_save :set_default

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :addFfp

  acts_as_indexed :fields => [:nickname,:forename,:surname, :email]
  acts_as_followable
  acts_as_follower

  belongs_to :invitor ,:class_name => 'User', :foreign_key => 'invitor_id'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname, :forename, :surname, :image, :admin, :trustcommunity, :invitor_id, :banned, :privacy, :legal, :legal_entity, :about_me

  validates :privacy, :inclusion => {:in => [true]}
  validates :legal, :inclusion => {:in => [true]}

  has_many :auctions
  has_many :userevents
  has_many :bids
  has_many :invitations
  has_many :ffps

  has_attached_file :image, :styles => { :medium => "520x360>", :thumb => "260x180#" , :mini => "130x90#"}
  validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :image, :in => 0..5.megabytes
  def fullname
    fullname = "#{self.forename} #{self.surname}"
  end

  def display_name
    fullname
  end

  def name
    name = "#{self.nickname}"
  end

  def addFfp
    if self.legal_entity == false
      Ffp.create(:price => 100, :user_id => self.id, :activated => true)
    end
  end

#def set_default
#if !self.admin && self.banned != false
# self.banned = true
#end
#end

end