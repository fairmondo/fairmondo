class AddressPolicy < Struct.new(:user, :address)

  def new?
    own?
  end

  def create?
    own?
  end

  def show?
    own?
  end

  def edit?
    own?
  end

  def update?
    own?
  end

  def destroy?
    own? && !standard_address?
  end

  private

    def standard_address?
      user.standard_address_id == address.id
    end

    def own?
      user && user.id == address.user_id
    end

    def own_collection?
      current_user.addresses.map
    end
end
