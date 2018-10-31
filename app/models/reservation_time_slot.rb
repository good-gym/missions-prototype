class ReservationTimeSlot < ApplicationRecord
  belongs_to :reservation
  belongs_to :time_slot
  has_one :runner, through: :reservation

  delegate :started_at, to: :time_slot
end
