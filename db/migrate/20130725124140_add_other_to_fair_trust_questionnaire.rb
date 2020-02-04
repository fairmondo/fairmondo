class AddOtherToFairTrustQuestionnaire < ActiveRecord::Migration[4.2]
  def change
    add_column :fair_trust_questionnaires, :support_other, :string
    add_column :fair_trust_questionnaires, :labor_conditions_other, :string
    add_column :fair_trust_questionnaires, :environment_protection_other, :string
    add_column :fair_trust_questionnaires, :controlling_other, :string
    add_column :fair_trust_questionnaires, :awareness_raising_other, :string
  end
end
