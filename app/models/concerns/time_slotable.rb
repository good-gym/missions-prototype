module TimeSlotable
  extend ActiveSupport::Concern

  included do
    has_many :time_slots, as: :booking, dependent: :destroy
    accepts_nested_attributes_for :time_slots

    validates :time_slots, length: { minimum: 1 }

    scope :upcoming, -> { joins(:time_slots).merge(TimeSlot.upcoming) }
    scope :in_month, lambda { |date|
      joins(:time_slots).merge(TimeSlot.in_month(date))
    }
    scope :starting_at, lambda { |started_at|
      joins(:time_slots).where(time_slots: { started_at: started_at })
    }

    scope :on_days, lambda { |days|
      joins(:time_slots).where("date_trunc('day', started_at) in (?)", days).distinct
    }
    scope :grouped_by_time, lambda { group(:started_at).count("*") }
    scope :grouped_by_date, lambda {
      group("date_trunc('day', started_at)")
      .count("*")
      .map { |t, value| [t.to_date, value] }.to_h
    }
  end
end
