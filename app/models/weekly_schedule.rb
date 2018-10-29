class WeeklySchedule
  DEFAULTS = YAML.load(File.read("config/weekly_schedules.yml"))
  def self.default(type)
    DEFAULTS[type]
  end

  attr_reader :schedule
  delegate :dig, :to_h, to: :schedule, allow_nil: true

  def initialize(data)
    @schedule = data.is_a?(Hash) ? parse_hash(data) : data
  end

  def +(other)
    WeeklySchedule.new add_schedule(schedule, other.schedule)
  end

  def days
    %[Mon Tue Wed Thu Fri Sat Sun]
  end

  def hours
    Array.new(12) { |i| format("%02d:00", i + 8) }
  end

  private

  def add_schedule(a, b)
    result = Hash.new { |hash, key| hash[key] = Hash.new(0) }

    7.times.map do |day|
      hours.each do |hour|
        result[day][hour] += a[day][hour] || 0
        result[day][hour] += b[day][hour] || 0
      end
    end

    result
  end

  def parse_hash(data)
    data.map do |day, hours|
      [day.to_i, hours.map { |hour, value| [hour, value.to_i] }.to_h]
    end.to_h
  end
end
