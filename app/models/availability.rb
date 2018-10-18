class Availability < ApplicationRecord
  include Postcodeable
  include TimeSlotable

  validates :radius, presence: true

  belongs_to :runner

  scope :owned_by, ->(runner) { where(runner: runner) }
  scope :not_owned_by, ->(runner) { where.not(runner: runner) }

  def radius_in_m
    radius * 1000
  end

  def in_range?(other)
    case other
    when Availability then postcode.distance_to(other.postcode) <= radius
    when Postcode then postcode.distance_to(other) <= radius
    else raise ArgumentError("Unable to see if other is in range")
    end
  end

  def geometry
    { type: "circle", lat: postcode.lat, lng: postcode.lng, radius: radius }
  end

  def status
    case time_slots.map { |t| t.nearby_runner_slots.size }.max
    when 0 then :waiting
    else :pending
    end
  end
end
