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
