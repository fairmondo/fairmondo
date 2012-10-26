module Tinycms
  module ApplicationHelper
    include Tinycms::Helper
        
    def return_to_path(fallback)
      session.delete(:return_to) || fallback
    end
    
  end
end
