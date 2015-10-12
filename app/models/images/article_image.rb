#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleImage < Image
  extend STI

  PROCESSING_IMAGE_URL = 'pending.png'

  has_attached_file(
    :image,
    styles: {
      original: { geometry: '900>x600>', animated: false },
      medium: { geometry: '520>x360>', animated: false },
      thumb: { geometry: '280x200>', animated: false }
    },
    convert_options: {
      medium: '-quality 75 -strip',
      thumb: '-quality 75 -strip -background white -gravity center -extent 260x180'
    },
    default_url: 'missing.png',
    url: '/system/images/:id_partition/:style/:filename',
    path: 'public/system/images/:id_partition/:style/:filename'
  )

  process_in_background :image, processing_image_url: PROCESSING_IMAGE_URL

  validates_attachment_presence :image, unless: :external_url
  validates_attachment_content_type :image,
                                    content_type: %w(
                                      image/jpeg image/png image/gif
                                    )
  validates_attachment_size :image, in: 1..20.megabytes # the 1 means one byte, not one megabyte

  belongs_to :article, foreign_key: 'imageable_id'

  def original_image_url_while_processing
    Paperclip::Interpolations.interpolate(
      ArticleImage.paperclip_definitions[:image][:url], self.image, :original
    )
  end

  def url_or_original_while_processing style = :thumb
    if image.processing?
      original_image_url_while_processing
    else
      image.url(style)
    end
  end
end
