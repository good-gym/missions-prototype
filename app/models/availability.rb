class Availability < ApplicationRecord
  include Postcodeable
  include Radiusable
  include TimeSlotable
  include MissionPreferences

  validates :radius, presence: true

  belongs_to :runner

  scope :owned_by, ->(runner) { where(runner: runner) }
  scope :not_owned_by, ->(runner) { where.not(runner: runner) }

  def status
    case time_slots.map { |t| t.nearby_runner_slots.size }.max
    when 0 then :waiting
    else :pending
    end
  end
end
