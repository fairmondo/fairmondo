class LibraryElementPolicy < Struct.new(:user, :library_element)

  def create?
    own?
  end

  def update?
    own?
  end

  def destroy?
    own?
  end

  private
  def own?
    user.id == library_element.library.user_id
  end

end
