class DailyDatum < ApplicationRecord
  validates :day, :production, :consumption, :disponibility, :wind_speed, presence: true
  belongs_to :wind_turbine
end
