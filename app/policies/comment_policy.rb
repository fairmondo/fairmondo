class CommentPolicy < Struct.new(:user, :comment)
  def create?
    logged_in?
  end

  def update?
    own?
  end

  def destroy?
    own?
  end

  private

  def logged_in?
    user
  end

  def own?
    user && user.id == comment.user_id
  end
end
