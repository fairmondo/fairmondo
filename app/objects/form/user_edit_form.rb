class UserEditForm < Reform::Form
  extend ActiveModel::Naming
  extend Enumerize
  include ActiveModel::Conversion
  include ActiveModel::Validations



  # User properties

  property :email, String
  property :forename, String
  property :surname, String
  property :nickname, String
  property :about_me, Text
  property :terms, Text
  property :cancellation, Text
  property :about, Text
  property :title, String
  property :phone, String
  property :mobile, String
  property :fax, String


  # Address properties

  collection :addresses do
    property :title, String
    property :first_name, String
    property :last_name, String
    property :address_line_1, String
    property :address_line_2, String
    property :zip, String
    property :city, String
    property :country, String
  end


  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

    def persist!
      @user = User.create!()

    end
end
