require 'plus_codes/open_location_code'

class Postcode < ApplicationRecord
  validates :postcode, uniqueness: true, presence: true, postcode: true
  after_commit :locate!
  serialize :geodata, HashSerializer

  scope :located, -> { where.not(lat: nil, lng: nil) }

  def self.postcode!(postcode_string, attributes = {})
    return if postcode_string.blank?

    uk_postcode = UKPostcode.parse(postcode_string)
    return unless uk_postcode.valid?

    Postcode.find_or_create_by(postcode: uk_postcode.to_s) do |postcode|
      postcode.assign_attributes(attributes)
    end
  end

  def postcode=(str)
    super UKPostcode.parse(str).to_s
  end

  def to_s
    postcode
  end

  def locate!
    return if lat.present? && lng.present?

    puts "Geocoding #{postcode}"
    geo = Geokit::Geocoders::GoogleGeocoder.geocode(postcode, components: { country: "UK" })

    update(lat: geo.lat, lng: geo.lng, geodata: geo.to_hash)
  end

  def locate_ideal_postcodes!
    return if geodata[:ideal].present?

    data = IdealPostcodes::Postcode.lookup(postcode).first
    Rails.logger.debug("Postcode lookup: #{postcode} - #{data.inspect}")

    self.lat ||= data[:latitude]
    self.lng ||= data[:longitude]
    geodata[:ideal] = data

    save!
  end

  def location
    @location ||= begin
      if geodata[:ideal].present?
        [geodata[:ideal][:ward], geodata[:ideal][:district]].compact.join(", ")
      else
        [uk_postcode.outcode, geodata[:district]].compact.join(", ")
      end
    end
  end

  def point
    @point ||= Geokit::LatLng.new(lat, lng)
  end

  def public_point
    @public_point ||= begin
      Geokit::LatLng.new(plus_code.latitude_center, plus_code.longitude_center)
    end
  end

  def public_bounds
    @public_bounds ||= begin
      Geokit::Bounds.new(
        Geokit::LatLng.new(plus_code.south_latitude, plus_code.west_longitude),
        Geokit::LatLng.new(plus_code.north_latitude, plus_code.east_longitude)
      )
    end
  end

  def distance_to(postcode)
    point.distance_to(postcode.point, units: :kms)
  end

  private

  def uk_postcode
    @uk_postcode ||= UKPostcode.parse(postcode)
  end

  def plus_code
    @plus_code ||= begin
      olc = PlusCodes::OpenLocationCode.new
      code = olc.encode(lat, lng, 8)
      code_area = olc.decode(code)
    end
  end
end
