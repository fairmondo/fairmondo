class ArticlePolicy < Struct.new(:user, :article)

  def index?
    true
  end

  def show?
    article.active || (user && own?)
  end

  def new?
    create?
  end

  def create?
    true # Devise already ensured this user is logged in.
  end

  def edit?
    update?
  end

  def update?
    own? && article.preview?
  end

  def destroy?
    false
  end

  def activate?
    user && own? && !article.active
  end

  def deactivate?
     user && own? && article.active
  end

  def report?
    user && !own?
  end

  private
  def own?
    user.id == article.seller.id
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
        scope.where(:active => true)
    end
  end


end



