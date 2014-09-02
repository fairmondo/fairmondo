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
module UsersHelper
  def user_resource
    @user
  end

  def active_articles
    resource.articles.where("state = ?", :active).includes(:images,:seller).page(params[:active_articles_page])
  end

  def inactive_articles
    resource.articles.where("state = ? OR state = ? OR state = ?", :preview, :locked, :inactive ).includes(:images,:seller).page(params[:inactive_articles_page])
  end

  def bought_line_item_groups
    resource.buyer_line_item_groups.sold.includes(:seller, :rating, :business_transactions => [:article => [:seller, :images]]).order(updated_at: :desc).page(params[:page]).per(6)
  end

  def sold_line_item_groups
    resource.seller_line_item_groups.sold.includes(:buyer, :rating, :business_transactions => [:article => [:images]]).order(updated_at: :desc).page(params[:page]).per(6)
  end

  def bank_account_line seller, attribute

    heading = content_tag(:div, class: 'heading' ) do
      "#{t("formtastic.labels.user.#{attribute}")}: "
    end
    value = content_tag(:div, class: 'value' ) do
      @line_item_group.seller.send(attribute)
    end
    content_tag(:div, class: 'line') do
      safe_join([heading,value])
    end
  end


end
