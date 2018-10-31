class Reservation < ApplicationRecord
  belongs_to :runner
  belongs_to :referral
  has_many :reservation_time_slots
  has_many :time_slots, through: :reservation_time_slots

  delegate :postcode, :title, :description, to: :referral
end
