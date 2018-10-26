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
    result = Hash.new { |hash, key| hash[key] = {} }

    7.times.map do |day|
      hours.each do |hour|
        result[day][hour] ||= 0
        result[day][hour] += 1 if a[day][hour]
        result[day][hour] += 1 if b[day][hour]
      end
    end

    result
  end

  def parse_hash(data)
    data.map { |key, value| [key.to_i, value] }.to_h
  end
end
