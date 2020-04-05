class Company < ApplicationRecord

  EO_LIEN = 1.freeze
  SEVE = 2.freeze

  has_many :users
end
