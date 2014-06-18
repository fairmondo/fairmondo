require 'reform/form/coercion'
require 'reform/rails'

class UserEditForm < Reform::Form
  include Reform::Form::ActiveRecord

  model :user, on: :user

  # User properties
  properties [
    :email,
   :forename,
   :surname,
   :nickname,
   :about_me,
   :terms,
   :cancellation,
   :about,
   :title,
   :phone,
   :mobile,
   :fax,
   :vacationing,
   :newsletter,
   :iban,
   :bic,
   :bank_account_owner,
   :bank_account_number,
   :bank_code,
   :bank_name,
   :direct_debit,
   :paypal_account,
   :company_name
  ], on: :user

  # Image properties
  properties [
      :image
    ], on: :image


  # Address properties
    collection :addresses, populate_if_empty: lambda { |input, args| model.addresses.build } do
     properties [
       :title,
       :first_name,
       :last_name,
       :address_line_1,
       :address_line_2,
       :zip,
       :city,
       :country
     ], on: :address
  end

  def persist!(params, user)
    if validate(params)
      successfully_updated = update_account(params.for(User).refine, user)

      save do |data, map|
        counter = 0
        data.addresses.each do |a|
          address = Address.find(a.model.id) ? Address.find(a.model.id) : user.addresses.build
          params[:user][:addresses_attributes][counter.to_s].delete(:id)
          address.update(params[:user][:addresses_attributes][counter.to_s])
          counter += 1
        end
      end
    end
  end

  private

    # check if we need password to update user data
    # ie if password or email was changed
    # extend this as needed
    # @api private
    def needs_password?(user, params)
      user.email != params[:email] || !params[:password].blank?
    end

    def update_account params, user
      if needs_password?(user, params)
        user.update_with_password(params)
      elsif params
        # remove the virtual current_password attribute for update_without_password
        # don't know how to ignore it
        params.delete(:current_password)
        params.delete(:addresses_attributes)
        user.update_without_password(params)
      end
    end
end
