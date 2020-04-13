class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :legal_name, :legal_agent
end
