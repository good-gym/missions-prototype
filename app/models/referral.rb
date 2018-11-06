class Referral < ApplicationRecord
  include FakeMissionData
  include Postcodeable
  include TimeSlotable
  include MissionPreferences
  include Referral::HasStateMachine
  attribute :preferences, :jsonb,
            default: -> { { lifting: false, cats: false, dogs: false, smoking: false } }

  def self.durations
    { 15 => "15 minutes or less",
      30 => "30 minutes",
      60 => "1 hour",
      90 => "Over an hour"
    }.to_a.map(&:reverse)
  end

  def self.states(relation = Referral.all)
    {
      pending: relation.pending,
      approved: relation.approved,
      scheduled: relation.scheduled,
      rejected: relation.in_state(:rejected),
      cancelled: relation.in_state(:cancelled),
      all: relation
    }
  end

  scope :pending, -> { in_state(:pending) }
  scope :approved, -> { in_state(:approved) }
  scope :scheduled, lambda {
    sql = <<~SQL
      join (
        select distinct booking_id, count(reservation_time_slots.reservation_id) from time_slots
        join reservation_time_slots on reservation_time_slots.time_slot_id = time_slots.id
        group by booking_id, booking_type, started_at
      ) t2 on t2.booking_id = referrals.id and t2.count >= referrals.volunteers_needed
    SQL
    joins(sql)
  }
  scope :not_scheduled, lambda {
    sql = <<~SQL
      join (
        select distinct booking_id, count(reservation_time_slots.reservation_id) from time_slots
        join reservation_time_slots on reservation_time_slots.time_slot_id = time_slots.id
        group by booking_id, booking_type, started_at
      ) t2 on t2.booking_id = referrals.id and t2.count < referrals.volunteers_needed
    SQL
    joins(sql)
  }

  belongs_to :referrer

  belongs_to :coach
  accepts_nested_attributes_for :coach

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

  attr_accessor :rejection_note

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

  def scheduled?
    time_slots.joins(:reservations)
      .having("count(reservations.*) >= ?", volunteers_needed)
      .group("time_slots.started_at")
      .any?
  end

  def geometry
    {
      center: postcode.public_point.to_a,
      shapes: [{ type: "circle", point: postcode.public_point.to_a, radius: 200 }]
    }
  end
end
