#
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

  def fair_label_css
     "Btn Btn-tag Btn-tag--blue"
  end

  def ecologic_label_css
    "Btn Btn-tag Btn-tag--green"
  end

  def small_and_precious_label_css
     "Btn Btn-tag Btn-tag--orange"
  end

  def get_social_producer_questionaire_for question, article
    html = ""
    if article.social_producer_questionnaire.send(question)

      html << "<p><b>" + t('formtastic.labels.social_producer_questionnaire.' + question.to_s) + "</b></p>"
      html << "<p>" + t('article.show.agree')+ "</p>"

      value = article.social_producer_questionnaire.attributes[question.to_s + "_checkboxes"]
      if value
        html << "<ul class=\"small\">"
        value.each do |purpose|
          html << "<li>" + t('enumerize.social_producer_questionnaire.' + question.to_s +  '_checkboxes.' + purpose) + "</li>"
        end
        html << "</ul>"
      end
    end
    html.html_safe
  end

  def get_fair_trust_questionaire_for question, article
    html = ""
    if article.fair_trust_questionnaire.send(question)

      html << "<p><b>" + t('formtastic.labels.fair_trust_questionnaire.' + question.to_s) + "</b></p>"
      html << "<p>" + t('article.show.agree')+ "</p>"

      value = article.fair_trust_questionnaire.attributes[question.to_s + "_checkboxes"]
      if value
        html << "<ul class=\"small\">"
        value.each do |purpose|
          html << "<li>" + t('enumerize.fair_trust_questionnaire.' + question.to_s +  '_checkboxes.' + purpose)
          if purpose == "other" && article.fair_trust_questionnaire.send(question.to_s + "_other")
            html << " " + article.fair_trust_questionnaire.send(question.to_s + "_other")
          end
          html << "</li>"
        end
        html << "</ul>"
      end

      html << "<p><b>" + t('formtastic.labels.fair_trust_questionnaire.' + question.to_s +  '_explanation') + "</b></p>"
      html << "<p>" + article.fair_trust_questionnaire.send(question.to_s + "_explanation") + "</p>"
    end
    html.html_safe
  end

  # Conditions
  def condition_label article
    # bclass=condition_badge_class(article.condition)
    '<span class="Btn Btn-tag Btn-tag--gray">'.html_safe + article.condition_text + "</span>".html_safe
  end

  def features_label article
    html = ""
    html << get_features_label(t("formtastic.labels.article.fair"), fair_label_css, article) if article.fair
    html << get_features_label(t("formtastic.labels.article.ecologic"), ecologic_label_css, article) if article.ecologic
    html << get_features_label(t("formtastic.labels.article.small_and_precious"), small_and_precious_label_css, article) if article.small_and_precious
    html.html_safe
  end

  def get_features_label text, btn_class, article
    if article_path(article) == request.path && btn_class =~ /Btn-tag /
      html = "<a href=\"#commendation\" class=\""+ btn_class +" accordion-anchor\">" + text + "</a>"
    else
      html = "<span class=\""+ btn_class +"\">" + text + "</span>"
    end
    html.html_safe
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

  def filter_class
    if params[:controller] == "articles" && params[:action] == "index"
      "is-active"
    else
      ""
    end
  end

  def categories_for_filter form
    if form.object.categories.length > 0
      tree = get_category_tree(form.object.categories.first)
      return tree.map { |category| category.id}.to_json
    end
    return [].to_json
  end

end
