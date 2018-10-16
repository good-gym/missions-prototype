class Runner < ApplicationRecord
  has_many :availabilities

  validates :name, presence: true
  validates :postcode, presence: true
end
