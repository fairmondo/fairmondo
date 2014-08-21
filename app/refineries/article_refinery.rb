class ArticleRefinery < ApplicationRefinery

  def create
    [
      # Common attrs
      :title, :content, :condition, :condition_extra, :quantity,
      :borrowable, :swappable,
      # :business_transaction_attributes, dont think they are needed right now
      # Money attrs
      :price_cents, :price, :vat,
      # Payment attrs
      :payment_details, :payment_bank_transfer, :payment_cash,
      :payment_paypal, :payment_invoice,
      :payment_cash_on_delivery, :payment_cash_on_delivery_price,
      :payment_cash_on_delivery_price_cents,
      #Basic price attrs
      :basic_price, :basic_price_cents, :basic_price_amount,
      # Transport attrs
      :transport_pickup,
      :transport_type1, :transport_type1_price_cents,
      :transport_type1_price, :transport_type1_provider,
      :transport_type1_number,
      :transport_type2, :transport_type2_price_cents,
      :transport_type2_price, :transport_type2_provider,
      :transport_type2_number,
      :transport_details,
      :transport_time,
      # Category attrs
      { category_ids: [] },
      # Commendation attrs
      :fair, :ecologic, :fair_kind, :fair_seal, :ecologic_seal,
      :ecologic_kind, :upcycling_reason, :small_and_precious,
      :small_and_precious_eu_small_enterprise, :small_and_precious_reason,
      :small_and_precious_handmade,
      { fair_trust_questionnaire_attributes: [
        # Question 1: supports marginalized workers (req)
        :support, :support_explanation, :support_other, {support_checkboxes:[]},
        # Question 2: labor conditions acceptable? (req)
        :labor_conditions, {labor_conditions_checkboxes:[]},
        :labor_conditions_explanation, :labor_conditions_other,
        # Question 3: is production environmentally friendly (opt)
        :environment_protection, {environment_protection_checkboxes:[]},
        :environment_protection_explanation, :environment_protection_other,
        # Question 4: does controlling of these standards exist (req)
        :controlling, {controlling_checkboxes:[]}, :controlling_explanation,
        :controlling_other,
        # Question 5: awareness raising programs supported? (opt)
        :awareness_raising, {awareness_raising_checkboxes:[]},
        :awareness_raising_explanation, :awareness_raising_other
      ]},
      { social_producer_questionnaire_attributes: [
        :nonprofit_association, {nonprofit_association_checkboxes:[]},
        :social_businesses_muhammad_yunus,
        {social_businesses_muhammad_yunus_checkboxes:[]},
        :social_entrepreneur, {social_entrepreneur_checkboxes:[]},
        :social_entrepreneur_explanation
      ]},
      # Image attrs
      { images_attributes: ImageRefinery.new(Image.new, user).default(true) },
      :image_2_url,
      # Legal Entity attrs
      :custom_seller_identifier, :gtin,
      # Fees and Donations attrs
      :friendly_percent, :friendly_percent_organisation_id,
      # Template attrs
      :save_as_template,
      :template_name

    ]
  end

  def update
    create
  end
end
