module TimeSlotable
  extend ActiveSupport::Concern

  included do
    has_many :time_slots, -> { order(started_at: :asc) },
             as: :booking, dependent: :destroy
    accepts_nested_attributes_for :time_slots

    validates :time_slots, length: { minimum: 1 }

    scope :upcoming, -> { joins(:time_slots).merge(TimeSlot.upcoming).distinct }
    scope :in_month, lambda { |date|
      joins(:time_slots).merge(TimeSlot.in_month(date))
    }
    scope :starting_at, lambda { |started_at|
      joins(:time_slots).where(time_slots: { started_at: started_at })
    }

    scope :on_days, lambda { |days|
      joins(:time_slots).where("date_trunc('day', started_at) in (?)", days)
    }
    scope :grouped_by_time, lambda { group(:started_at).count("*") }
    scope :grouped_by_date, lambda {
      joins(:time_slots)
        .where("started_at > now()")
        .select("date_trunc('day', started_at)::date as date")
        .distinct
        .group_by(&:date)
    }
  end

  def dates
    time_slots.map(&:started_at).map(&:to_date).uniq
  end
end
