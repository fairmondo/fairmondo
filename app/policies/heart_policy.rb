class HeartPolicy < Struct.new(:user, :heart)
  def create?
    true
  end
end
