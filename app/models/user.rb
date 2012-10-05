class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  acts_as_indexed :fields => [:name, :surname, :email]
  acts_as_followable
  acts_as_follower
 
  belongs_to :invitor ,:class_name => 'User', :foreign_key => 'invitor_id'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :surname, :image, :invitor, :admin, :trustcommunity
  
  has_many :auctions
  has_many :userevents
  has_many :bids
  has_many :invitations
  has_many :ffps
  
  has_attached_file :image, :styles => { :medium => "520x360>", :thumb => "260x180#" , :mini => "130x90#"} 
  validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :image, :in => 0..5.megabytes 
  def fullname
    fullname = "#{self.name} #{self.surname}" 
  end
  
  
  
end
