module Scada
  class ParcTenMinutesValues

    attr_reader :time, :active_power

    def initialize(time, active_power)
      @time = time
      @active_power = active_power.to_f
    end
  end
end
