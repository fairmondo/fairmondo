class ExhibitPolicy < Struct.new(:user, :exhibit)

  def update?
    admin?
  end

  def create?
    admin?
  end

  def create_multiple?
    admin?
  end

  def destroy?
    admin?
  end

  private
  def admin?
    User.is_admin? user
  end

end
