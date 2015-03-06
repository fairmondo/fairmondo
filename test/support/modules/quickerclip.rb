#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
# Stubbing out Paperclip. Should prevent ImageMagick being required to run tests
# https://gist.github.com/brentvatne/2967528

$paperclip_stub_size = "520x360"


module Paperclip
  class Geometry
    def self.from_file file
      parse($paperclip_stub_size)
    end
  end
  class Thumbnail
    def make
      src = fixture_file_upload('spec/fixtures/test2.png')
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode
      FileUtils.cp(src.path, dst.path)
      return dst
    end
  end
  class Attachment
    def post_process *attrs
    end
  end
  # module Storage
  #   module Filesystem
  #     def flush_writes
  #       @queued_for_write.each{|style, file| file.close}
  #       @queued_for_write = {}
  #     end
  #     def flush_deletes
  #       @queue_for_delete = []
  #     end
  #   end
  # end
end
