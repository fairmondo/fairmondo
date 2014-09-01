class LibraryRefinery < ApplicationRefinery

  def default
    permitted = [ :name, :public, :user, :user_id ]
    permitted += [ :exhibition_name ] if User.is_admin? user
    permitted
  end
end
