class Availability::Match
  def self.near(postcode, relation = Availability.upcoming)
    postcode.locate!

    relation
      .group("time_slots.started_at")
      .pluck(:started_at, "array_agg(availabilities.id)")
      .flat_map do |started_at, ids|
        in_range = Availability.find(ids).select { |a| a.in_range?(postcode) }
        new(started_at: started_at, availabilities: in_range) if in_range.any?
      end
      .compact
  end

  def self.all(relation = Availability.upcoming)
    relation
      .group("time_slots.started_at")
      .pluck(:started_at, "array_agg(availabilities.id)")
      .flat_map do |started_at, ids|
        split_by_overlap(Availability.find(ids))
          .map { |as| new(started_at: started_at, availabilities: as) }
      end
  end

  def self.split_by_overlap(availabilities)
    availabilities.map do |availability|
      availabilities.select do |a|
        distance = availability.postcode.distance_to(a.postcode)
        distance < availability.radius && distance < a.radius
      end
    end.uniq
  end

  attr_reader :started_at, :availabilities

  delegate :size, to: :availabilities

  def initialize(started_at:, availabilities:)
    @started_at = started_at
    @availabilities = availabilities
  end

  def date
    started_at.to_date
  end

  def runners
    availabilities.map(&:runner)
  end

  def covers?(postcode)
    availabilities.map { |a| a.in_range?(postcode) }.uniq == [true]
  end

  def overlap?
    combos_overlap = availabilities.combination(2).map do |a, b|
      distance = a.postcode.distance_to(b.postcode)
      distance < a.radius && distance < b.radius
    end
    combos_overlap.uniq == [true]
  end
end
