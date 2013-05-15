class FairTrustQuestionnaire < ActiveRecord::Base

  attr_accessible :support, :support_explanation,
   :transparency, :transparency_explanation,
   :collaboration,:collaboration_explanation,
   :minimum_wage, :minimum_wage_explanation,
   :child_labor, :child_labor_explanation,
   :sexual_equality, :sexual_equality_explanation ,
   :labor_conditions, :labor_conditions_explanation,
   :producer_advancement,:producer_advancement_explanation,
   :awareness_raising, :awareness_raising_explanation,
   :environment_protection,:environment_protection_explanation

  belongs_to :article

  validates_presence_of :support
  validates_presence_of :support_explanation
  validates_presence_of :transparency
  validates_presence_of :transparency_explanation

  validates_presence_of :minimum_wage
  validates_presence_of :minimum_wage_explanation
  validates_presence_of :child_labor_explanation, :if => :child_labor?

  validates_presence_of :sexual_equality
  validates_presence_of :sexual_equality_explanation

  # :collaboration_explanation
  # :labor_conditions_explanation
  # :producer_advancement_explanation
  # :awareness_raising_explanation
  # :environment_protection_explanation

end