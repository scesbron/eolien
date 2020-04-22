# frozen_string_literal: true

module Api
  class WindFarmsController < ApplicationController
    before_action :authenticate_user!

    def init
      wind_farm = current_user.company.wind_farm
      session_id = Scada::Api.login
      handle = Scada::Api.get_status_handle(session_id, wind_farm, 10_000)
      render json: {
        sessionId: session_id,
        handle: handle
      }
    end

    def status
      wind_farm = current_user.company.wind_farm
      render json: Scada::Api.status(params[:sessionId], params[:handle], wind_farm)
    end
  end
end
