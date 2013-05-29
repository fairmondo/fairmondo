class UserPolicy < Struct.new(:user, :resource)

 def profile?
   true
 end

 def show?
   true
 end

end



