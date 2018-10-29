class Alert < ApplicationRecord
  include Radiusable
  include Postcodeable
  serialize :weekly_schedule, HashSerializer

  attribute :enabled, :boolean, default: true

  belongs_to :runner, touch: true
  attr_accessor :availability_preset
  scope :enabled, -> { where(enabled: true) }

  def self.availabilities
    [
      nil,
      ["Weekends", :weekend],
      ["Weekends and before work", :weekend_before_work],
      ["Weekends and after work", :weekend_after_work],
      ["Weekends and before/after work", :weekend_before_after_work],
      ["Lunch times", :lunchtimes],
      ["Lunch and before work", :lunchtimes_before_work],
      ["Lunch and after work", :lunchtimes_after_work],
      ["Lunch and before/after work", :lunchtimes_before_after_work],
      ["All the time", :all],
      ["At specific times", :none]
    ]
  end

  def weekly_schedule
    WeeklySchedule.new(super)
  end

  def weekly_schedule=(data)
    super WeeklySchedule.new(data).to_h
  end
end
