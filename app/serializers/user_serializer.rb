class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :firstname, :lastname, :email, :phone, :address, :additional_address,
             :zip_code, :city, :city_code, :shareholder_number, :role, :civility, :maiden_name,
             :birth_date, :birth_country, :birth_department, :birth_city_code, :birth_city

  has_many :loans
  has_many :shares
  belongs_to :company
end
