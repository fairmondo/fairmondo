class LibraryPolicy < Struct.new(:user, :library)

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
      user.id == library.user_id
    end

    class Scope < Struct.new(:current_user,:user, :scope)
      def resolve
          if current_user.id == user.id
            scope
          else
            scope.public
          end
      end
    end

end
