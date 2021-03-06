class Alert::Finder
  attr_reader :postcode, :alerts
  delegate :any?, to: :alerts

  def self.near(postcode, relation = Alert.enabled)
    return if postcode.blank?

    new(postcode, relation.in_range(postcode))
  end

  def initialize(postcode, alerts)
    @postcode = postcode
    @alerts = alerts.includes(:postcode, :runner)
  end

  def scored_schedule(_date)
    return Hash.new({}) if joint_schedule == 0

    joint_schedule.score
  end

  def joint_schedule
    @joint_schedule ||= alerts.map(&:weekly_schedule).sum
  end

  def runners
    alerts.map(&:runner)
  end

  def best_times
    []
  end

  def summarise
    [
      available_all_days.any? ? "All day #{available_all_days.to_sentence}" : nil
    ].compact
  end

  def geometry
    {
      center: postcode.point.to_a,
      shapes: [
        { type: "marker", point: postcode.point.to_a },
        alerts.map(&:geometry)
      ].flatten
    }
  end

  private

  def available_all_days
    joint_schedule
      .schedule
      .select { |_day, hours| hours.values.all?(&:positive?) }
      .map { |day, _hours| DAYS[day] }
  end

  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
end
