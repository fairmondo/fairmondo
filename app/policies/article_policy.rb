#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
    return false if user.blank?

    original = article.original
    if original && original.seller != article.seller
      return false
    end
    return true
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
    # owned_and_deactivated? || own? && article.template?
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
    own? && (article.preview? || article.locked?)
  end

  def bought_or_sold?
    LineItemGroup.where(id: article.business_transactions.pluck(:line_item_group_id)).where('seller_id = ? OR buyer_id = ?', user, user).limit(1).any?
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(state: 'active').includes(:images, :seller)
    end
  end
end
