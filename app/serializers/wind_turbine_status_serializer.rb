class WindTurbineStatusSerializer < ActiveModel::Serializer
  attributes :name, :instant_power, :wind_speed, :disponibility, :total_production
end
