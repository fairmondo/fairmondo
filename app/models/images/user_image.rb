class UserImage < Image
  extend STI
    has_attached_file :image, styles: { original: "300>x300>", profile: "300x300#" },
                            convert_options: { profile: "-quality 75 -strip" },
                            default_url: "/assets/missing.png",
                            url: "/system/images/:id_partition/:style/:filename",
                            path: "public/system/images/:id_partition/:style/:filename",
                            only_process: [:profile]
    belongs_to :user, foreign_key: "imageable_id"

    validates_attachment_presence :image, :unless => :external_url
    validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
    validates_attachment_size :image, :in => 0..2.megabytes

end