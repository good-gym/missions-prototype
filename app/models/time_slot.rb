class TimeSlot < ApplicationRecord
  belongs_to :booking, polymorphic: true

  scope :upcoming, -> { where("started_at > now()") }
  scope :in_month, lambda { |date|
    where(time_slots: { started_at: (date.beginning_of_month..date.end_of_month) })
  }

  validate :started_at_must_be_at_start_of_hour

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

  private

  def started_at_must_be_at_start_of_hour
    return if started_at.to_s == started_at.beginning_of_hour.to_s

    errors.add(:started_at, "must be at the start of the hour")
  end
end
