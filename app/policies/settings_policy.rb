class SettingsPolicy < Struct.new(:user, :library)

  def update?
    admin?
  end

  private
  def admin?
    User.is_admin? user
  end

end
