class TimeSlot < ApplicationRecord
  belongs_to :booking, polymorphic: true

  default_scope { order(:started_at) }
  scope :upcoming, -> { where("started_at > now()") }
  scope :in_month, lambda { |date|
    where(time_slots: { started_at: (date.beginning_of_month..date.end_of_month) })
  }

  validate :started_at_must_be_at_start_of_hour

  delegate :postcode, to: :booking

  def owner
    case booking
    when Availability then booking.runner
    when Referral then booking.referrer
    else raise "?"
    end
  end

  def nearby_runner_slots
    Availability
      .near(booking.postcode, booking.radius)
      .joins(:time_slots)
      .not_owned_by(owner)
      .where(time_slots: { started_at: started_at })
      .includes(:time_slots)
      .map(&:time_slots)
      .flatten
  end

  def nearby_referrals
    Referral
      .near(booking.postcode, booking.radius)
      .joins(:time_slots)
      .where(time_slots: { started_at: started_at })
      .where.not(time_slots: { id: id })
      .uniq
  end

  def status
    case nearby_runner_slots.size
    when 0 then :waiting
    else :pending
    end
  end

  private

  def started_at_must_be_at_start_of_hour
    return if started_at.to_s == started_at.beginning_of_hour.to_s

    errors.add(:started_at, "must be at the start of the hour")
  end
end
