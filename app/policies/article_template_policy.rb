#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleTemplatePolicy < Struct.new(:user, :article_template)
  def new?
    create?
  end

  def create?
    own?
  end

  def edit?
    update?
  end

  def update?
    own?
  end

  def destroy?
    own?
  end

  private

  def own?
    user.id == article_template.user_id
  end
end
