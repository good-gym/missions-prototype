class Runner < ApplicationRecord
  has_many :availabilities, as: :owner

  validates :name, presence: true
end
