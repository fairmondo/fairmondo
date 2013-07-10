#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module ApplicationHelper


  def hero
    hero = ""
    begin

       if @rendered_hero
         hero += render :partial => "/hero/#{@rendered_hero[:controller]}/#{@rendered_hero[:action]}"
       else
         hero += render :partial => "/hero/#{params[:controller]}/#{params[:action]}"
       end
        rescue ActionView::MissingTemplate
          begin
            hero += render :partial => "/hero/#{params[:controller]}/default"

          rescue ActionView::MissingTemplate

          end
     end
      return hero.html_safe
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
      truncate(Sanitize.clean(text), length: length, separator: separator, omission: omission ).gsub("\n", ' ')
  end

  def search_cache
    Article.new(params[:article])
  end

  # Login form anywhere - https://github.com/plataformatec/devise/wiki/How-To:-Display-a-custom-sign_in-form-anywhere-in-your-app
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
