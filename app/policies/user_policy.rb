class UserPolicy < Struct.new(:user, :resource)

 def profile?
   user && true
 end

 def show?
   user && true
 end

end



