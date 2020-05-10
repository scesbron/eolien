# frozen_string_literal: true

module Api
  class WindFarmsController < ApplicationController
    before_action :authenticate_user!

    def init
      wind_farm = current_user.company.wind_farm
      session_id = Scada::Api.login
      handle = Scada::Api.get_status_handle(session_id, wind_farm, 10_000)
      min_date, max_date = DailyDatum.pluck('min(day), max(day)').first
      render json: {
        sessionId: session_id,
        handle: handle,
        minDate: min_date,
        maxDate: max_date,
        turbinePower: wind_farm.turbine_power,
        turbineCount: wind_farm.wind_turbines.enabled.count
      }
    end

    def status
      render json: Scada::Api.status(params[:sessionId], params[:handle], current_user.company.wind_farm)
    end

    def monthly_data
      @day = get_day
      @productibles = Productible.where(month: @day.month).to_a
      @data = DailyDatum
                .where('day >= ?', @day.beginning_of_month)
                .where('day <= ?', @day.end_of_month)
                .group(:day)
                .order(:day)
                .pluck('day, sum(production - consumption)')
                .map{|day, value| [day, value || 0]}
      @ratio = @data.map(&:first).max.day * 1.0 / @day.end_of_month.day
      @production = @data.map(&:last).sum
      render json: {
        productibles: @productibles,
        labels: @data.map{ |datum| I18n.l(datum[0], format: :day) },
        values: @data.map{ |datum| datum[1] }
      }
    end

    private

    def get_day(name = :day)
      day = Date.parse(params[name])
      minDate, maxDate = DailyDatum.pluck('min(day), max(day)').first
      day = minDate if day < minDate
      day = maxDate if day > maxDate
      return day
    end
  end
end
