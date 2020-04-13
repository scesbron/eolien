class UserShareSerializer < ActiveModel::Serializer
  attributes :id, :date, :quantity
  belongs_to :share
end
