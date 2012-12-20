class FairTrustQuestionnaire < ActiveRecord::Base
  
  belongs_to :auction
  
  validates_presence_of :support_explanation
  validates_presence_of :transparency_explanation
      
  validates_presence_of :minimum_wage_explanation
  validates_presence_of :child_labor_explanation, :if => :child_labor?
   
  validates_presence_of :sexual_equality_explanation
      
  # :collaboration_explanation
  # :labor_conditions_explanation
  # :producer_advancement_explanation
  # :awareness_raising_explanation
  # :environment_protection_explanation
  
end