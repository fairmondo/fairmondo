#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module ApplicationHelper
  def title(title = nil)
    if title.present?
      content_for :title, title
    elsif content_for?(:title)
      content_for(:title) + t('article.show.title_addition')
    else
      t('shared.fairmondo.name')
    end
  end

  def meta_keywords(tags = nil)
    if tags.present?
      content_for :meta_keywords, tags
    elsif content_for?(:meta_keywords)
      [content_for(:meta_keywords), t('shared.meta_tags.keywords')].join ', '
    else
      t('shared.meta_tags.keywords')
    end
  end

  def meta_description(desc = nil)
    if desc.present?
      content_for :meta_description, desc
    elsif content_for?(:meta_description)
      content_for(:meta_description)
    else
      t('shared.meta_tags.description')
    end
  end

  def truncate_and_sanitize_without_linebreaks(text = '', length = 70, omission = '', separator = ' ')
    truncate(Sanitize.clean(text), length: length, separator: separator, omission: omission).gsub("\n", ' ')
  end

  def clickable_legal_links(html)
    odr_url = /https?:\/\/ec.europa.eu\/(consumers\/)?odr\/?/
    html.to_s.gsub(odr_url) do |url|
      "<a href=\"#{url}\" target=\"_blank\">#{url}</a>"
    end
  end

  # Login form anywhere - https://github.com/plataformatec/devise/wiki/How-To:-Display-a-custom-sign_in-form-anywhere-in-your-app
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Rails 4 included feature
  def cache_if(condition, name = {}, &block)
    if condition
      cache(name, &block)
    else
      yield
    end
  end

  # CSS Layout helper
  # By default will render css from controller/NAME_OF_THE_CONTROLLER.css
  # overwrite if you need somehing else
  def controller_specific_css_path
    @controller_specific_css ||= controller_name
    css_path = "controller/#{@controller_specific_css}.css"
  # behavior of Rails.application.assets changed in rails 3.5.2 for production environment
  # see https://github.com/rails/sprockets-rails/issues/294
    if Rails.application.config.assets.compile
      Rails.application.assets.find_asset(css_path)
    end
  #  return nil unless Rails.application.assets.find_asset(css_path).present?
    css_path
  end

  def money value
    humanized_money_with_symbol value
  end

  def resource
    @controlled_resource ||= instance_variable_get("@#{controller_name.classify.underscore}")
  end

  def current_cart
    @current_cart ||= ::Cart.where(user_id: current_user ? current_user.id : nil).open.find_by_id cookies.signed[:cart]
  end

  def on_login_page?
    controller_name == 'sessions'
  end

  def navigation_push
    on_login_page? ? {} : { push: true }
  end
end
