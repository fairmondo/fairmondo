namespace :iban do
  desc "generate iban and bic from KntNr and Plz"
  task :generate => :environment do
    User.all.each do |user|
      if !user.bank_code.blank? && !user.bank_account_number.blank? && user.iban.blank? && user.bic.blank?

        bank_info = Ibanomat.find :bank_code => user.bank_code, :bank_account_number => user.bank_account_number
        if !bank_info[:iban].blank? && !bank_info[:bic].blank? && bank_info[:return_code] == "00"
          #puts bank_info[:iban]
          #puts bank_info[:bic]
          user.update_attribute(:iban, bank_info[:iban])
          user.update_attribute(:bic, bank_info[:bic])
        end
      end
    end
  end
end
