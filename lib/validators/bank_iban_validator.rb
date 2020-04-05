class BankIbanValidator < ActiveModel::EachValidator

  # https://fr.wikipedia.org/wiki/International_Bank_Account_Number#Algorithme_de_v.C3.A9rification_de_l.27IBAN
  def validate_each(record, attribute, value)
    value = (value || '').gsub(' ','')
    if value.to_s =~ /^[A-Z]{2}/i
      iban = value.gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
      if (iban[6..-1].to_s+iban[0..5].to_s).to_i % 97 != 1
        record.errors.add(attribute, :invalid_bank_iban)
      end
    else
      record.errors.add(attribute, :invalid_bank_iban)
    end
  end
end
