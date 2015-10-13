#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module UsersHelper
  def user_resource
    @user
  end

  def active_articles
    resource.articles.where('state = ?', :active).includes(:images, :seller).page(params[:active_articles_page])
  end

  def inactive_articles
    resource.articles.where('state = ? OR state = ? OR state = ?', :preview, :locked, :inactive).includes(:images, :seller).page(params[:inactive_articles_page])
  end

  def bought_line_item_groups
    resource.buyer_line_item_groups.sold.includes(:seller, :rating, business_transactions: [article: [:seller, :images]]).order(updated_at: :desc).page(params[:buyer_line_item_groups_page])
  end

  def sold_line_item_groups
    resource.seller_line_item_groups.sold.includes(:buyer, :rating, business_transactions: [article: [:images]]).order(updated_at: :desc).page(params[:seller_line_item_groups_page])
  end

  def bank_account_line seller, attribute
    heading = content_tag(:div, class: 'heading') do
      "#{t("formtastic.labels.user.#{attribute}")}: "
    end
    value = content_tag(:div, class: 'value') do
      seller.send(attribute)
    end
    content_tag(:div, class: 'line') do
      safe_join([heading, value])
    end
  end
end
