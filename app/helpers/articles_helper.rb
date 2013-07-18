#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module ArticlesHelper
  # Conditions
  def condition_label article
    # bclass=condition_badge_class(article.condition)
    html = "<span class=\"Btn Btn-tag Btn-tag--gray\">" + article.condition_text + "</span>"
    html.html_safe
  end

  def features_label article
    html = ""
    html +="<span class=\"Btn Btn-tag Btn-tag--blue\">" + t("formtastic.labels.article.fair")+ "</span>" if article.fair
    html +="<span class=\"Btn Btn-tag Btn-tag--green\">" + t("formtastic.labels.article.ecologic")+ "</span>" if article.ecologic
    html +="<span class=\"Btn Btn-tag Btn-tag--orange\">" + t("formtastic.labels.article.small_and_precious")+ "</span>" if article.small_and_precious

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

  def title_image
    if params[:image]
      resource.images.find(params[:image])
    else
      resource.images[0]
    end
  end

  def thumbnails title_image
    thumbnails = resource.images
    thumbnails.reject!{|image| image.id == title_image.id}  #Reject the selected image from thumbs
    thumbnails
  end

  def find_fair_alternative_to article
    search = Article.search do
      fulltext article.title do
        boost(3.0) { with(:fair, true) }
        boost(2.0) { with(:ecologic, true) }
        boost(1.0) { with(:condition, :old) }
      end
      without(article)
      any_of do
        with :fair,true
        with :ecologic,true
        with :condition, :old
      end
    end
    return search.results.first
  rescue Errno::ECONNREFUSED
    return nil
  end

  #seems unused. remove unless problems arise.
  def libraries
    resource.libraries.where(:public => true).paginate(:page => params[:page], :per_page=>10)
  end

  def active_seller_articles
    resource.seller.articles.where(:state => "active").paginate(:page => params[:page], :per_page=>18)
  end

  def payment_format_for type
    html=""
    if resource.send("payment_" + type)
      html = t('formtastic.labels.article.payment_'+type)
    end
    html.html_safe
  end

end
