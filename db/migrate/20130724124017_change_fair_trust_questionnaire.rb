class ChangeFairTrustQuestionnaire < ActiveRecord::Migration[4.2]
  def up
    # old fields
    remove_column :fair_trust_questionnaires, :transparency
    remove_column :fair_trust_questionnaires, :transparency_explanation
    remove_column :fair_trust_questionnaires, :collaboration
    remove_column :fair_trust_questionnaires, :collaboration_explanation
    remove_column :fair_trust_questionnaires, :minimum_wage
    remove_column :fair_trust_questionnaires, :minimum_wage_explanation
    remove_column :fair_trust_questionnaires, :child_labor
    remove_column :fair_trust_questionnaires, :child_labor_explanation
    remove_column :fair_trust_questionnaires, :sexual_equality
    remove_column :fair_trust_questionnaires, :sexual_equality_explanation
    remove_column :fair_trust_questionnaires, :producer_advancement
    remove_column :fair_trust_questionnaires, :producer_advancement_explanation

    # new checkboxes
    add_column :fair_trust_questionnaires, :support_checkboxes, :text
    add_column :fair_trust_questionnaires, :labor_conditions_checkboxes, :text
    add_column :fair_trust_questionnaires, :environment_protection_checkboxes, :text
    add_column :fair_trust_questionnaires, :controlling_checkboxes, :text
    add_column :fair_trust_questionnaires, :awareness_raising_checkboxes, :text

    # new fields
    add_column :fair_trust_questionnaires, :controlling, :boolean, default: false
    add_column :fair_trust_questionnaires, :controlling_explanation, :text

    # change defaults
    change_column :fair_trust_questionnaires, :support, :boolean, default: false
    change_column :fair_trust_questionnaires, :labor_conditions, :boolean, default: false
    change_column :fair_trust_questionnaires, :environment_protection, :boolean, default: false
    change_column :fair_trust_questionnaires, :awareness_raising, :boolean, default: false
  end

  def down
    # old fields
    add_column :fair_trust_questionnaires, :transparency, :boolean
    add_column :fair_trust_questionnaires, :transparency_explanation, :text
    add_column :fair_trust_questionnaires, :collaboration, :boolean
    add_column :fair_trust_questionnaires, :collaboration_explanation, :text
    add_column :fair_trust_questionnaires, :minimum_wage, :boolean
    add_column :fair_trust_questionnaires, :minimum_wage_explanation, :text
    add_column :fair_trust_questionnaires, :child_labor, :boolean
    add_column :fair_trust_questionnaires, :child_labor_explanation, :text
    add_column :fair_trust_questionnaires, :sexual_equality, :boolean
    add_column :fair_trust_questionnaires, :sexual_equality_explanation, :text
    add_column :fair_trust_questionnaires, :producer_advancement, :boolean
    add_column :fair_trust_questionnaires, :producer_advancement_explanation, :text

    # new checkboxes
    remove_column :fair_trust_questionnaires, :support_checkboxes
    remove_column :fair_trust_questionnaires, :labor_conditions_checkboxes
    remove_column :fair_trust_questionnaires, :environment_protection_checkboxes
    remove_column :fair_trust_questionnaires, :controlling_checkboxes
    remove_column :fair_trust_questionnaires, :awareness_raising_checkboxes

    # new fields
    remove_column :fair_trust_questionnaires, :controlling
    remove_column :fair_trust_questionnaires, :controlling_explanation

    # remove defaults
    change_column :fair_trust_questionnaires, :support, :boolean
    change_column :fair_trust_questionnaires, :labor_conditions, :boolean
    change_column :fair_trust_questionnaires, :environment_protection, :boolean
    change_column :fair_trust_questionnaires, :awareness_raising, :boolean
  end
end
