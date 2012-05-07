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
    "<i class=\"" + name + "\"></i>".html_safe
  end
  
  def glyphicons_inv(name)
    "<i class=\"" + name + " icon-white\"></i>".html_safe
  end
  
  ### Others ###
   
end
