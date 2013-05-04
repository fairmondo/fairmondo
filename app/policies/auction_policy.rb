class AuctionPolicy < Struct.new(:user, :auction)

    def index?
      true
    end

    def show?
      auction.active || (user && own?)
    end

    def new?
      create?
    end

    def create?
      user.valid? #cant harm to check that
    end
    
    def edit?
      update?
    end
    
    def update?

      own? && !auction.locked
    end
    
    def destroy?
      false
    end
    
    def activate?
      user && own? && !auction.active
    end
    
    def deactivate?
       user && own? && auction.active
    end
    
    def report?
      user && !own?
    end
    
    private 
    def own?
      user.id == auction.seller.id
    end
    
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.where(:active => true)
      end
    end
    

end



