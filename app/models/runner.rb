class Runner < ApplicationRecord
  has_many :availabilities

  validates :name, presence: true
end
