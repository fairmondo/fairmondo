#https://github.com/thoughtbot/paperclip/issues/1429

#TODO: when the issue is cosed update paperclip and remove this

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end