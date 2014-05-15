class UserImage < Image
  extend STI
  has_attached_file :image, styles: { original: "300>x300>", profile: "300x300>" },
                          convert_options: { profile: "-quality 75 -strip -background white -gravity center -extent 300x300" },
                          default_url: lambda { |image| ActionController::Base.helpers.asset_path("missing.png")} ,
                          path: "public/system/images/:id_partition/:style/:filename",
                          only_process: [:profile]
  belongs_to :user, foreign_key: "imageable_id"

  validates_attachment_presence :image, :unless => :external_url
  validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :image, :in => 1..2.megabytes # the 1 means one byte, not one megabyte

end
