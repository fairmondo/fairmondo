class AddExplanationToSocialProducer < ActiveRecord::Migration[4.2]
  def change
    add_column  :social_producer_questionnaires, :social_entrepreneur_explanation, :text
  end
end
