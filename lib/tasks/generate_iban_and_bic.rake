namespace :iban do
  desc "generate iban and bic from KntNr and Plz"
  task :generate => :environment do

    user_without_iban = 0
    user_with_valid_kntNr = 0

    User.all.each do |user|
      if user.bank_code? && user.bank_account_number? && !user.iban? && !user.bic?
        user_without_iban += 1
        bank_info = Ibanomat.find :bank_code => user.bank_code, :bank_account_number => user.bank_account_number
        if !bank_info[:iban].blank? && !bank_info[:bic].blank? && bank_info[:return_code] == "00"
          user_with_valid_kntNr += 1
          #puts bank_info[:iban]
           #puts bank_info[:bic]
          user.update_attribute(:iban, bank_info[:iban])
          user.update_attribute(:bic, bank_info[:bic])
        end
      end
    end
    puts "User without iban but with kntNr and Blz: " + user_without_iban.to_s
    puts "User without iban and correct kntNr and Blz: " + user_with_valid_kntNr.to_s

  end
end
