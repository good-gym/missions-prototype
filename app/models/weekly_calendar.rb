class WeeklyCalendar
  attr_reader :date, :times

  delegate :dig, to: :times

  def initialize(date = Date.today)
    @date = date.to_date.beginning_of_week
    @times = {}
  end

  def days
    @days ||= Array.new(7) { |d| date.beginning_of_week + d }
  end

  def next_week
    @date + 1.week
  end

  def previous_week
    @date - 1.week
  end

  def current?
    previous_week.end_of_week.future?
  end

  def to_s
    [date, date + 7.days].map { |s| s.to_s(:short) }.join(" - ")
  end
end
