module ApplicationHelper

  # Glyph Icons Helpers
  def glyphicons(name)
    "<i class=\"" + name + "\"></i>".html_safe
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
      content_for?(:title) ? content_for(:title) + t('article.show.title_addition') : t('common.fairnopoly')
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

  def truncate_and_sanitize_without_linebreaks(text = "", length = 70, omission ='', separator = ' ')
      truncate(sanitize( text ,:tags => %w(),:attributes => %w() ),
        :length => length, :separator =>separator, :omission=>omission ).gsub("\n", ' ')
  end

  def search_cache
    Article.new(params[:article])
  end

end
