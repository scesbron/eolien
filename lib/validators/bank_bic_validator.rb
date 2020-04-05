class BankBicValidator < ActiveModel::EachValidator
  MIN_LENGTH = 8

  def validate_each(record, attribute, value)
    bank_bic_num = (value || '').gsub(' ','')
    if bank_bic_num.size >= MIN_LENGTH
      bank_bic_num = "#{bank_bic_num}#{'X' * [11 - bank_bic_num.size, 0].max }"
      if bank_bic_num =~ /\A[a-z]{6}[0-9a-z]{2}([0-9a-z]{3})?\Z/i
        value = bank_bic_num
      else
        record.errors.add(attribute)
      end
    else
      record.errors.add(attribute, :bank_bic_too_short, count: MIN_LENGTH)
    end
  end
end
