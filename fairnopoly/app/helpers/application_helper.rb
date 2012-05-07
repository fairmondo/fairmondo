module ApplicationHelper
  #### Bootstrap Helpers ####
  
  # Map Flash to Bootstrap CSS
  def bootstrap_notice_mapper(type)
    case type
    when :alert
      "warning"
    when :error
      "error"
    when :notice
      "success"
    else
    "info"
    end
  end
  
  # Glyph Icons Helpers 
  def glyphicons(name)
    "<i class=\"" + name + "\"></i>"
  end
  
  def glyphicons_inv(name)
    "<i class=\"" + name + " icon-white\"></i>"
  end
  
  ### Others ###
   
end
