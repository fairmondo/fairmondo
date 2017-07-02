#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserImage < Image
  extend STI

  belongs_to :user, foreign_key: 'imageable_id'

  after_commit :copy_to_gcs
  before_destroy :delete_from_gcs

  PAPERCLIP_STORAGE_OPTIONS = {
    path: 'public/system/images/:id_partition/:style/:filename',
    url: '/system/images/:id_partition/:style/:filename',
    default_url: '/assets/missing.png',
    styles: {
      original: { geometry: '300>x300>', animated: false },
      profile:  { geometry: '300x300>',  format: :jpg, animated: false },
      thumb:    { geometry: '60x60#',    format: :jpg, animated: false }
    },
    convert_options: {
      profile: '-quality 75 -strip -background white -gravity center -extent 300x300',
      thumb: '-quality 75 -strip -background white'
    },
    only_process: [:profile, :thumb]
  }

  migrate_options = YAML.load(ERB.new(File.read("#{Rails.root}/config/google_migrate.yml")).result).symbolize_keys
  PAPERCLIP_STORAGE_OPTIONS.merge!(migrate_options) if migrate_options[:activated_user_images]

  has_attached_file :image, PAPERCLIP_STORAGE_OPTIONS

  validates_attachment_presence :image, unless: :external_url
  validates_attachment_content_type :image, content_type: %w(image/jpeg image/png image/gif)
  validates_attachment_size :image, in: 1..20.megabytes # the 1 means one byte, not one megabyte

  def copy_to_gcs
    setup_connection
    styles = [:original, :profile, :thumb]
    styles.each do |style|
      path = image.path(style)
      # filename cannot be used directly because extension can be different
      filename = path.split("/").last
      object_name = "user_images/images/#{self.id}/#{style}/#{filename}"
      file = File.open(path)
      @connection.put_object(@bucket_name, object_name, file,
        'x-goog-acl' => 'public-read')
    end
  end

  def delete_from_gcs
    setup_connection
    styles = [:original, :profile, :thumb]
    styles.each do |style|
      begin
        path = image.path(style)
        # filename cannot be used directly because extension can be different
        filename = path.split("/").last
        object_name = "user_images/images/#{self.id}"
        @connection.delete_object(@bucket_name, object_name)
      rescue
      end
    end
  end

  private
    def setup_connection
      access_key  = Rails.application.secrets.google_storage_access_key_id
      secret_key  = Rails.application.secrets.google_storage_secret_access_key
      @connection = Fog::Storage::Google.new google_storage_access_key_id: access_key,
                                             google_storage_secret_access_key: secret_key
      @bucket_name = Rails.application.secrets.google_bucket_name
    end
end
