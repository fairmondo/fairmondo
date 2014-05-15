class FeedbackImage < Image
  extend STI

  has_attached_file :image, styles: { original: "300>x300>" },
                          default_url: ':default_image_url' ,
                          url: "/system/images/:id_partition/:style/:filename",
                          path: "public/system/images/:id_partition/:style/:filename"
  belongs_to :feedback, foreign_key: "imageable_id"

  validates_attachment_presence :image, unless: :external_url
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png']
  validates_attachment_size :image, in: 0..2.megabytes

end