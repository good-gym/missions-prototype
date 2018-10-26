class Alert < ApplicationRecord
  include Radiusable
  include Postcodeable
  serialize :weekly_schedule, HashSerializer

  attribute :enabled, :boolean, default: true

  belongs_to :runner
  attr_accessor :availability_preset
  scope :enabled, -> { where(enabled: true) }

  def self.availabilities
    [
      ["Weekends and before/after work"],
      ["Lunch and before/after work"],
      ["All the time"]
    ]
  end

  def weekly_schedule
    WeeklySchedule.new(super)
  end

  def weekly_schedule=(data)
    super WeeklySchedule.new(data).to_h
  end
end
