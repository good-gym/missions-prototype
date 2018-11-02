class WeeklySchedule
  DEFAULTS = YAML
    .safe_load(File.read("config/weekly_schedules.yml"))
    .with_indifferent_access

  def self.default(type = nil)
    type ||= (DEFAULTS.keys - ["none"]).sample
    DEFAULTS[type]
  end

  attr_reader :schedule, :count
  delegate :dig, :to_h, to: :schedule, allow_nil: true

  def initialize(data, count = 1)
    @schedule = data.is_a?(Hash) ? parse_hash(data) : data
    @count = count
  end

  def +(other)
    WeeklySchedule.new(
      add_schedule(schedule, other.schedule),
      count + other.count
    )
  end

  def days
    %w[Mon Tue Wed Thu Fri Sat Sun]
  end

  def hours
    Array.new(12) { |i| format("%02d:00", i + 8) }
  end

  def score
    result = Hash.new { |hash, key| hash[key] = Hash.new(0) }

    7.times.each do |day|
      hours.each do |hour|
        result[day][hour] = schedule[day][hour] / count.to_f
      end
    end

    result
  end

  private

  def add_schedule(a, b)
    result = Hash.new { |hash, key| hash[key] = Hash.new(0) }

    7.times.each do |day|
      hours.each do |hour|
        result[day][hour] += a.dig(day, hour) || 0
        result[day][hour] += b.dig(day, hour) || 0
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
