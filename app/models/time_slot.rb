class TimeSlot < ApplicationRecord
  belongs_to :availability

  delegate :owner, to: :availability

  def nearby_slots
    TimeSlot
      .where(started_at: started_at)
      .joins(:availability)
      .where.not(availabilities: { owner: owner })
  end
end
