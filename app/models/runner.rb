class Runner < ApplicationRecord
  include Postcodeable
  include MissionPreferences
  has_many :availabilities

  validates :name, presence: true
  validates :postcode, presence: true
end
