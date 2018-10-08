class Availability < ApplicationRecord
  include Postcodeable
  belongs_to :owner, polymorphic: true

  has_many :time_slots
  accepts_nested_attributes_for :time_slots

  validates :time_slots, length: { minimum: 1 }

  scope :on_days, lambda { |days|
    joins(:time_slots).where("date_trunc('day', started_at) in (?)", days)
  }
  scope :in_month, lambda { |date|
    joins(:time_slots).where(time_slots: { started_at: (date.beginning_of_month..date.end_of_month) })
  }
  scope :grouped_by_time, lambda { group(:started_at).count("*") }
  scope :grouped_by_date, lambda {
    group("date_trunc('day', started_at)")
    .count("*")
    .map { |t, value| [t.to_date, value] }.to_h
  }
end
