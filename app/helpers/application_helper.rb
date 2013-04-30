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
  
  def main_notice_mapper(type)
    case type
    when :alert
      "error"
    when :error
      "error"
    when :notice
      "info"
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
  
  def params_without key
    new_param = Hash.new
    new_param.merge!(params)
    new_param.delete key
    new_param
  end
  
   def params_without_reset_page key
    new_param = Hash.new
    new_param.merge!(params)
    new_param.delete key
    new_param.delete "page"
    new_param
  end
  
  def params_with key, value
    new_param = Hash.new
    new_param.merge!(params)
    new_param[key] = value
    new_param
  end
  
  def params_replace(old, new, value)
     new_param = Hash.new
     new_param.merge!(params)
     new_param[new] = value
     new_param.delete old
     new_param
  end
   
  def hero
    hero = "<div id=\"hero\">"
    begin 
       
       if @rendered_hero
         hero += render :partial => "/hero/#{@rendered_hero[:controller]}/#{@rendered_hero[:action]}"
       else
         hero += render :partial => "/hero/#{params[:controller]}/#{params[:action]}"
       end
       
       hero << "</div>"   
        rescue ActionView::MissingTemplate
          begin
            hero += render :partial => "/hero/#{params[:controller]}/default"
            hero << "</div>"   
          rescue ActionView::MissingTemplate 
            hero = ""
          end
     end
      return hero.html_safe
  end
  
  def render_tooltip tooltip
    tip = "<a class=\"input-tooltip\"><span>"
    tip += tooltip
    tip += "</span></a>"
    tip.html_safe
  end
  
  def title(title = nil)
    if title.present?
      content_for :title, title
    else
      content_for?(:title) ? content_for(:title) + t('auction.show.title_addition') : t('common.fairnopoly')
    end
  end
  
  def meta_keywords(tags = nil)
    if tags.present?
      content_for :meta_keywords, tags
    else
      content_for?(:meta_keywords) ? [content_for(:meta_keywords), t('meta_tags.keywords')].join(', ') : t('meta_tags.keywords')
    end
  end

  def meta_description(desc = nil)
    if desc.present?
      content_for :meta_description, desc
    else
      content_for?(:meta_description) ? content_for(:meta_description) : t('meta_tags.description')
    end
  end
  
  
end
