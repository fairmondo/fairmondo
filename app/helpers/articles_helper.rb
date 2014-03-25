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
    condition_text = t("enumerize.article.condition.#{article.condition}")
    "<span class=\"Btn Btn-tag Btn-tag--gray\">#{condition_text}</span>".html_safe
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
      output += "<a href='#{articles_path(article: {category_ids: [category.id] })}' class='#{(last ? 'last' : nil )}'>"
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
      query do
        boolean do
          must { match "title.search", article.title, fuzziness: 0.8}
          must do
            boolean :minimum_number_should_match => 1 do
              should { term :fair, true, boost: 10.0  }
              should { term :ecologic, true, boost: 5.0 }
              should { term :condition, "old", boost: 1.0 }
            end
          end
        end
      end
      filter :terms, :categories => Article::Categories.specific_search_categories(article.categories)
      size 1
    end
    alternative = search.first

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
    if article.condition == "old"
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
      output +=     "<a href='#{articles_path(article: {category_ids: [child.id]})}'>"
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

  # Returns true if the basic price should be shown to users
  #
  # @return Boolean
  def show_basic_price_for? article
    article.belongs_to_legal_entity? && article.basic_price_amount && article.basic_price && article.basic_price > 0
  end

  # Returns true if the friendly_percent should be shown
  #
  # @return Boolean
  def show_friendly_percent_for? article
    article.friendly_percent && article.friendly_percent > 0 && article.friendly_percent_organisation && !article.seller_ngo
  end

  def show_fair_percent_for? article
    # for german book price agreement
    # we can't be sure if the book is german
    # so we dont show fair percent on all new books
    # book category is written in exceptions.yml
    !article.could_be_book_price_agreement? && article.friendly_percent != 100
  end

end
