module Postcodeable
  extend ActiveSupport::Concern

  included do
    belongs_to :postcode, autosave: true, optional: true

    scope :near, lambda { |postcode, distance|
      postcode.locate!
      distance_sql = <<~SQL
        (6371 * ACOS(
          COS(RADIANS(#{postcode.lat})) * COS(RADIANS(postcodes.lat)) *
          COS(RADIANS(#{postcode.lng}) - RADIANS(postcodes.lng)) +
          SIN(RADIANS(#{postcode.lat})) * SIN(RADIANS(postcodes.lat)))
        )
      SQL

      joins(:postcode).where("#{distance_sql} <= ?", distance)
    }
  end

  def postcode_str
    postcode&.postcode
  end

  def postcode_str=(string)
    self.postcode = Postcode.find_or_initialize_by(postcode: string)
  end
end
