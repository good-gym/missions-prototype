class Referral < ApplicationRecord
  include FakeMissionData
  include Postcodeable
  include TimeSlotable
  include MissionPreferences
  attribute :preferences, :jsonb, default: -> { { lifting: false, cats: false, dogs: false } }

  def self.durations
    { 15 => "15 minutes or less",
      30 => "30 minutes",
      60 => "1 hour",
      90 => "Over an hour"
    }.to_a.map(&:reverse)
  end

  scope :pending, -> { where(approved_by_id: nil, approved_at: nil) }
  scope :approved, -> { where.not(approved_by_id: nil, approved_at: nil) }

  belongs_to :referrer

  belongs_to :coach
  accepts_nested_attributes_for :coach

  belongs_to :approved_by, class_name: "Coordinator", optional: true

  has_many :reservations

  attr_accessor :title
  attr_accessor :subtitle
  attr_accessor :description

  attr_accessor :contact_details
  attr_accessor :task_notes
  attr_accessor :risk
  attr_accessor :risk_details

  attr_accessor :confirm_age
  attr_accessor :confirm_tools

  attr_reader :confirmation_by_time
  def confirmation_by_time=(time)
    super
    case time
    when nil then self.confirmation_by = nil
    when :hour_1 then self.confirmation_by = 1.hour.from_now
    when :hour_3 then self.confirmation_by = 3.hours.from_now
    when :tomorrow_morning then self.confirmation_by = Time.now.end_of_day + 8.hours
    when :tomorrow_evening then self.confirmation_by = Time.now.end_of_day + 16.hours
    end
  end

  def geometry
    {
      center: postcode.public_point.to_a,
      shapes: [{ type: "circle", point: postcode.public_point.to_a, radius: 200 }]
    }
  end
end
