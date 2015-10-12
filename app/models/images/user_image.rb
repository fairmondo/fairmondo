#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserImage < Image
  extend STI
  has_attached_file(
    :image,
    styles: {
      original: { geometry: '300>x300>', animated: false },
      profile:  { geometry: '300x300>',  format: :jpg, animated: false },
      thumb:    { geometry: '60x60#',    format: :jpg, animated: false }
    },
    convert_options: {
      profile: '-quality 75 -strip -background white -gravity center -extent 300x300',
      thumb: '-quality 75 -strip -background white'
    },
    default_url: '/assets/missing.png',
    url: '/system/images/:id_partition/:style/:filename',
    path: 'public/system/images/:id_partition/:style/:filename',
    only_process: [:profile, :thumb]
  )

  belongs_to :user, foreign_key: 'imageable_id'

  validates_attachment_presence :image, unless: :external_url
  validates_attachment_content_type :image,
                                    content_type: %w(
                                      image/jpeg image/png image/gif
                                    )
  validates_attachment_size :image, in: 1..20.megabytes # the 1 means one byte, not one megabyte
end
