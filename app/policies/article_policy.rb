#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class ArticlePolicy < Struct.new(:user, :article)

  def index?
    true
  end

  def show?
    # Active or sold articles can be shown to anyone.
    # All other state except of closedcan be shown to the
    # user who owns this article.
    article.active? || article.sold? || (own? && !article.closed?) || bought_or_sold? || User.is_admin?(user)
  end

  def new?
    create?
  end

  def create?
    original = article.original
    #binding.pry
    if original && original.seller == article.seller && (original.closed? || original.sold? || original.locked?)
      true
    elsif !original
      true
    else
      false # Devise already ensured this user is logged in.
    end
    # FUTURE: Maybe we should deny this for possible guest access.
  end

  def edit?
    update?
  end

  def update?
    # Edititng an article is only allowed in preview state.
    # After this we should generate a new article on editing.
    # Refer to ArticlesController#new with params edit_as_new.
    own? && (article.preview? || article.template?)
  end

  def destroy?
    own?
    #owned_and_deactivated? || own? && article.template?
  end

  def activate?
    owned_and_deactivated?
  end

  def deactivate?
    user && own? && article.active?
  end

  def report?
    ((user && !own?) || !user)  && article.active?
  end

  def purchasable?
    not_owned_and_active? && !article.seller_vacationing?
  end

  def purchasable_later?
    not_owned_and_active? && article.seller_vacationing?
  end

  private
    def own?
      user && user.id == article.seller.id
    end

    def not_owned_and_active?
      article.active? && !own?
    end

    def owned_and_deactivated?
      own? && ( article.preview? || article.locked? )
    end

    def bought_or_sold?
      LineItemGroup.where(id: article.business_transactions.pluck(:line_item_group_id)).where("seller_id = ? OR buyer_id = ?",user,user).limit(1).any?
    end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(:state => "active").includes(:images,:seller)
    end
  end
end
