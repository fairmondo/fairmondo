class ChangeTransportLabels < ActiveRecord::Migration[4.2]
  def change
    rename_column(:articles,:transport_insured,:transport_type1)
    rename_column(:articles,:transport_uninsured,:transport_type2)
    rename_column(:articles,:transport_insured_provider,:transport_type1_provider)
    rename_column(:articles,:transport_uninsured_provider,:transport_type2_provider)
    rename_column(:articles,:transport_insured_price_cents,:transport_type1_price_cents)
    rename_column(:articles,:transport_uninsured_price_cents,:transport_type2_price_cents)
  end
end
