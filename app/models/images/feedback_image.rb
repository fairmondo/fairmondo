#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FeedbackImage < Image
  extend STI

  has_attached_file(
    :image,
    styles: {
      original: { geometry: '300>x300>', animated: false }
    },
    default_url: '/assets/missing.png',
    url: '/system/images/:id_partition/:style/:filename',
    path: 'public/system/images/:id_partition/:style/:filename'
  )

  belongs_to :feedback, foreign_key: 'imageable_id'

  validates_attachment_presence :image, unless: :external_url
  validates_attachment_content_type :image,
                                    content_type: %w(image/jpeg image/png)
  validates_attachment_size :image, in: 0..2.megabytes
end
