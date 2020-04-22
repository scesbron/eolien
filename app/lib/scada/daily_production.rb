module Scada
  class DailyProduction

    attr_reader :timer, :data_runtime, :data_availability, :counter20, :counter21, :counter16,
      :counter17, :mean_power, :capacity, :wind_speed, :availability, :grid_outage

    def initialize(
      timer, data_runtime, data_availability, counter20, counter21, counter16,
      counter17, mean_power, capacity, wind_speed, availability, grid_outage)
      @timer = timer
      @data_runtime = data_runtime
      @data_availability = data_availability
      @counter20 = counter20
      @counter21 = counter21
      @counter16 = counter16
      @counter17 = counter17
      @mean_power = mean_power
      @capacity = capacity
      @wind_speed = wind_speed
      @availability = availability
      @grid_outage = grid_outage
    end

    def production
      counter20 + counter21
    end

    def consumption
      counter16 + counter17
    end

    def availability_rate
      availability * 100.0 / timer
    end
  end
end
