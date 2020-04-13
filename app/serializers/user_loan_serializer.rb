class UserLoanSerializer < ActiveModel::Serializer
  attributes :id, :date, :quantity
  belongs_to :loan
end
