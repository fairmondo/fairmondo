class UserRefinery < ApplicationRefinery
  def self.root
    false
  end

  def create
    [
      :email, :password, :new_terms_confirmed,
      # and custom fields apart from devise internal stuff:
      :nickname, :type, :newsletter, :legal, :privacy
    ]
  end

  def update
    permitted = [
      :current_password, # <- update specific
      :email, :password, :password_confirmation, :remember_me, :type,
      :nickname, :legal, :paypal_account,
      :banned, :about_me, :bank_code,
      :phone, :mobile, :fax, :direct_debit,
      :bank_account_number, :bank_name, :bank_account_owner, :company_name, :max_value_of_goods_cents_bonus,
      :fastbill_profile_update, :vacationing, :newsletter, :receive_comments_notification,
      :iban, :bic,
      :unified_transport_provider, :unified_transport_maximum_articles, :unified_transport_price,
      :free_transport_available, :free_transport_at_price,
      { image_attributes: ImageRefinery.new(Image.new, user).default }
    ]
    permitted += [:terms, :cancellation, :about, :cancellation_form] if user.is_a? LegalEntity
    permitted
  end
end
