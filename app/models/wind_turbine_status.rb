# frozen_string_literal: true

class WindTurbineStatus < ActiveModelSerializers::Model

  attributes :name, :instant_power, :wind_speed, :disponibility, :total_production

  def initialize(name, instant_power, wind_speed, disponibility, total_production)
    @name = name
    @instant_power = instant_power
    @wind_speed = wind_speed
    @disponibility = disponibility
    @total_production = total_production
  end
end
