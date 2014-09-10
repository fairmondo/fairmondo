module Assets
  module Normalizer
    def self.included(base)
      base.send :before_save, :normalize_filename
    end

    private

    def normalize_filename
      self.class.attachment_definitions.each do |name, hash|
        attachment = self.send(name)
        if attachment.present?
          normalized_file_name = Assets::Filename.normalize(attachment.instance_read(:file_name))
          attachment.instance_write(:file_name, normalized_file_name )
        end
      end
    end
  end

end