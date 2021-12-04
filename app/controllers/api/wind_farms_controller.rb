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

    def daily_data
      start_time = Time.parse(params[:day]).localtime.beginning_of_day.utc
      end_time = start_time + 24.hours
      wind_farm = current_user.company.wind_farm
      data = wind_farm.wind_turbines.ordered_by_number.enabled.map do |turbine|
        turbine_data = Scada::Api.turbine_ten_minutes_values(params[:sessionId], turbine, start_time, end_time)
        {
          name: turbine.name,
          labels: turbine_data.map { |datum| datum.time.localtime.min.zero? ? datum.time.localtime.strftime('%H') : '' },
          power: turbine_data.map(&:active_power),
          wind_speed: turbine_data.map(&:wind_speed)
        }
      end
      render json: data
    end

    def monthly_data
      @day = get_day
      productibles = Productible.where(month: @day.month).to_a
      @data = DailyDatum
                .where('day >= ?', @day.beginning_of_month)
                .where('day <= ?', @day.end_of_month)
                .group(:day)
                .order(:day)
                .pluck(:day, DailyDatum.arel_table[:production].sum, DailyDatum.arel_table[:consumption].sum)
                .map{|day, production, consumption| [day, (production || 0) - (consumption || 0)]}
      render json: {
        productibles: productibles,
        labels: @data.map{ |datum| I18n.l(datum[0], format: :day) },
        values: @data.map{ |datum| datum[1] },
        goals: @data.map{ |_| (productibles.first.value / @day.end_of_month.day).round },
        ratio: @data.map(&:first).max.day * 1.0 / @day.end_of_month.day,
        production: @data.map(&:last).sum
      }
    end

    def yearly_data
      @start_date = get_day(:startDate)
      @end_date = get_day(:endDate)
      productibles = Productible.all.to_a
      data = DailyDatum
               .where('day >= ?', @start_date)
               .where('day <= ?', @end_date)
               .group('1,2')
               .order('2,1')
               .pluck(DailyDatum.arel_table[:day].month, DailyDatum.arel_table[:day].year, DailyDatum.arel_table[:production].sum, DailyDatum.arel_table[:consumption].sum)
               .map{|month, _, production, consumption| [I18n.t("date.month_names")[month], (production || 0) - (consumption || 0)]}
      labels = data.map(&:first)
      render json: {
        labels: labels,
        values: data.map(&:last),
        goals: labels.map{|label| productibles.select{|p| I18n.t("date.month_names")[p.month]==label}.first}.map(&:value)
      }
    end

    private

    def get_day(name = :day)
      day = Date.parse(params[name])
      minDate = DailyDatum.pluck('min(day)').first
      maxDate = Date.today
      day = minDate if day < minDate
      day = maxDate if day > maxDate
      return day
    end
  end
end
