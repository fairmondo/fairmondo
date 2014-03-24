# encoding: utf-8
#
# == License:
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
module ArticlesHelper


  # Conditions
  def condition_label article
    # bclass=condition_badge_class(article.condition)
    '<span class="Btn Btn-tag Btn-tag--gray">'.html_safe + article.condition_text + "</span>".html_safe
  end

  # Build title string
  def index_title_for search_article
    attribute_list = ::HumanLanguageList.new
    attribute_list << t('article.show.title.new') if search_article.condition == 'new'
    attribute_list << t('article.show.title.old') if search_article.condition == 'old'
    attribute_list << t('article.show.title.fair') if search_article.fair
    attribute_list << t('article.show.title.ecologic') if search_article.ecologic
    attribute_list << t('article.show.title.small_and_precious') if search_article.small_and_precious

    output = attribute_list.concatenate.capitalize + ' '

    if search_article.categories[0]
      output += search_article.categories[0].name + ' '
    end
    output += t('article.show.title.article')
  end

  def breadcrumbs_for category_leaf
    category_tree = get_category_tree category_leaf
    output = ''
    category_tree.each do |category|
      last = category_tree.last == category
      output += '<span>'
      output += "<a href='#{articles_path(article: {categories_and_ancestors: category.self_and_ancestors_ids })}' class='#{(last ? 'last' : nil )}'>"
      output += category.name
      output += '</a>'
      output += '</span>'
      output += ' > ' unless last
    end

    output
  end

  def get_category_tree category
    tree = []
    cat = category
    tree.unshift(cat)

    while parent_cat = parent_category(cat)
      tree.unshift(parent_cat)
      cat = parent_cat
    end
    return tree
  end

  def parent_category cat
    Category.where(:id => cat.parent_id).first
  end

  def find_fair_alternative_to article
    search = Article.search do
      fulltext article.title do
        boost(3.0) { with(:fair, true) }
        boost(2.0) { with(:ecologic, true) }
        boost(1.0) { with(:condition, :old) }
        minimum_match 1
        exclude_fields(:content)
        fields(:title)
      end
      without(article)
      with :category_ids, Article::Categories.specific_search_categories(article.categories)
      any_of do
        with :fair,true
        with :ecologic,true
        with :condition, :old
      end
    end
    alternative = search.results.first
    if rate_article(article) < rate_article(alternative)
      return alternative
    else
      return nil
    end
  rescue # Rescue all Errors by not showing an alternative
    return nil
  end

  def rate_article article
    if article == nil
      return 0
    end
    if article.fair
      return 3
    end
    if article.ecologic
      return 2
    end
    if article.condition.old?
      return 1
    end
    return 0
  end

  def libraries
    resource.libraries.where(:public => true).page(params[:page]).per(10)
  end

  def active_seller_articles
    resource.seller.articles.includes(:images).where(:state => "active").page(params[:page]).per(18)
  end

   def transport_format_for method, css_classname=""
    type = "transport"
    options_format_for type, method, css_classname
  end

  def payment_format_for method, css_classname=""
    type = "payment"
    options_format_for type, method, css_classname
  end

  def options_format_for type, method, css_classname
    if resource.send(type + "_" + method)
      html = "<li class= "+ css_classname +" >"

      if method == "type1" || method == "type2"
        html << resource.send(type + "_" + method + "_provider" ) + " "
      else
        html << t('formtastic.labels.article.'+ type +'_'+ method)+ " "
      end

      attach_price = type + "_" + method+"_price"

      if resource.respond_to?(attach_price.to_sym)
        html << "zzgl. "
        html << humanized_money_with_symbol(resource.send(attach_price))
      else
         html << "(kostenfrei)"
      end

      if type == "transport" && method == "pickup"
        html << ", <br/>PLZ: #{resource.seller.zip}"
      end

      html <<"</li>"
      html.html_safe
    end
  end

  def categories_for_filter form
    if form.object.categories.length > 0
      tree = get_category_tree(form.object.categories.first)
      return tree.map { |category| category.id}.to_json
    end
    return [].to_json
  end

  def build_category_table children, columns = 2
    last = children.count - 1
    last_in_column = columns - 1

    output = "<table class='Category-dropdown-children Category-dropdown-children--columns-#{columns}'>"
    children.each_with_index do |child, index|
      output += '<tr>' if index % columns == 0
      output +=   '<td>'
      output +=     "<a href='#{articles_path(article: {categories_and_ancestors: child.self_and_ancestors_ids})}'>"
      output +=       child.name
      output +=     '</a>'
      output +=   '</td>'
      output += '</tr>' if (index % columns) == last_in_column or index == last
    end
    output += '</table>'
  end

  def default_organisation_from organisation_list
    begin
      organisation_name = default_form_value('friendly_percent_organisation', resource)
      default_organisation = organisation_list.select { |o| o.nickname == organisation_name }
      default_organisation[0] ? default_organisation[0].id : nil
    rescue
      nil
    end
  end
end
