class Image < ActiveRecord::Base

  attr_accessible :image

  belongs_to :article
  has_attached_file :image, :styles => { :medium => "520x360>", :thumb => "260x180#" , :mini => "130x90#"}
  validates_attachment_presence :image
  validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :image, :in => 0..5.megabytes
end