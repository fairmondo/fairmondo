
class UserEditForm
  extend ActiveModel::Naming
  extend Enumerize
  include Virtus.model
  include ActiveModel::Conversion
  include ActiveModel::Validations



  # User attributes
  attribute :email, String
  attribute :forename, String
  attribute :surname, String
  attribute :nickname, String
  attribute :about_me, Text
  attribute :terms, Text
  attribute :cancellation, Text
  attribute :about, Text
  attribute :title, String
  attribute :phone, String
  attribute :mobile, String
  attribute :fax, String

  # Address attributes
  attribute :title, String
  attribute :first_name, String
  attribute :last_name, String
  attribute :address_line_1, String
  attribute :address_line_2, String
  attribute :zip, String
  attribute :city, String
  attribute :country, String


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
