class HeartPolicy < Struct.new(:user, :heart)
  def create?
    true
  end

  def destroy?
    own?
  end

  private

  def own?
    user && user.id == heart.user_id
  end
end
