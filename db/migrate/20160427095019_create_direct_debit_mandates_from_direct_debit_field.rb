class CreateDirectDebitMandatesFromDirectDebitField < ActiveRecord::Migration
  def up
    LegalEntity.where(direct_debit: true).each do |user|
      creator = CreatesDirectDebitMandate.new(user)
      mandate = creator.create

      # Change mandate creation date to approximate date of our SEPA mandate changeover
      time = [Time.new(2015, 3, 1), user.created_at].max

      mandate.created_at = time
      mandate.save

      user.update_fastbill_profile
    end
  end

  def down
    DirectDebitMandate.destroy_all
  end
end
