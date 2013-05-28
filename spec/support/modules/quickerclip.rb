# Stubbing out Paperclip. Should prevent ImageMagick being required to run tests
# https://gist.github.com/brentvatne/2967528

RSpec.configure do |config|
  $paperclip_stub_size = "520x360"
end

module Paperclip
  class Geometry
    def self.from_file file
      parse($paperclip_stub_size)
    end
  end
  class Thumbnail
    def make
      src = fixture_file_upload('spec/fixtures/test.png')
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode
      FileUtils.cp(src.path, dst.path)
      return dst
    end
  end
  class Attachment
    def post_process
    end
  end
  module Storage
    module Filesystem
      def flush_writes
        @queued_for_write.each{|style, file| file.close}
        @queued_for_write = {}
      end
      def flush_deletes
        @queue_for_delete = []
      end
    end
  end
end
