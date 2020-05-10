module Scada
  class TurbineTenMinutesValues

    attr_reader :time, :active_power, :operating_state, :wind_speed, :wind_direction

    def initialize(time, active_power, operating_state, wind_speed, wind_direction)
      @time = time
      @active_power = active_power.to_f
      @operating_state = operating_state.to_f
      @wind_speed = wind_speed.to_f
      @wind_direction = wind_direction.to_f
    end

    def running?
      (11..15).include?(@operating_state)
    end

    def state
      if operating_state.zero?
        'NO DATA'
      elsif running?
        'RUN'
      else
        "STATE : #{value.operating_state}"
      end
    end
  end
end
