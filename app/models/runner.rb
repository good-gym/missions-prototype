class Runner < ApplicationRecord
  include Postcodeable
  include MissionPreferences
  has_many :alerts, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  has_many :reservations, dependent: :destroy

  validates :name, presence: true
end
