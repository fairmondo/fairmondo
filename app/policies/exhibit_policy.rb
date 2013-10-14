class ExhibitPolicy < Struct.new(:user, :exhibit)

  def update?
    admin?
  end

  def create?
    admin?
  end

  private
  def admin?
    User.is_admin? user
  end

end
