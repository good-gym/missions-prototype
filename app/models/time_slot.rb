class TimeSlot < ApplicationRecord
  belongs_to :booking, polymorphic: true

  def owner
    case booking
    when Availability then booking.runner
    when Referral then booking.referrer
    else raise "?"
    end
  end

  def nearby_runner_slots
    TimeSlot
      .where(started_at: started_at)
      .joins("join availabilities on availabilities.id = booking_id and booking_type = 'Availability'")
      .where("runner_id != ?", owner.id)
  end

  def nearby_referral_slots
    TimeSlot
      .where(started_at: started_at)
      .joins("join referrals on referrals.id = booking_id and booking_type = 'Referral'")
      .where.not(id: id)
  end
end
