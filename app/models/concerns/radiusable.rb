module Radiusable
  extend ActiveSupport::Concern

  included do
    scope :in_range, lambda { |postcode|
      distance_sql = <<~SQL
        (6371 * ACOS(
          COS(RADIANS(#{postcode.lat})) * COS(RADIANS(postcodes.lat)) *
          COS(RADIANS(#{postcode.lng}) - RADIANS(postcodes.lng)) +
          SIN(RADIANS(#{postcode.lat})) * SIN(RADIANS(postcodes.lat)))
        )
      SQL

      joins(:postcode).where("#{distance_sql} <= radius")
    }
  end

  def radius_in_m
    radius * 1000
  end

  def in_range?(other)
    case other
    when other&.postcode then postcode.distance_to(other.postcode) <= radius
    when Postcode then postcode.distance_to(other) <= radius
    else raise ArgumentError("Unable to see if other is in range")
    end
  end

  def geometry
    { type: "circle", point: postcode.point, radius: radius_in_m }
  end
end
