class CommentPolicy < Struct.new(:user, :comment)
  def create?
    if comment.commentable_type == 'Article' && comment.commentable_user.vacationing? # commentable_type may be nil if not set
      return false
    end
    logged_in?
  end

  def destroy?
    own? || admin?
  end

  private
    def logged_in?
      user
    end

    def own?
      user && user.id == comment.user_id
    end

    def admin?
      User.is_admin? user
    end
end
