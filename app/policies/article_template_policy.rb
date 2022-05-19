#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
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
    user == article_template.user
  end
end
