class TimeSlot::Match
  def self.near(postcode, relation = TimeSlot.upcoming)
    all(relation).select { |m| m.covers?(postcode) }
  end

end
