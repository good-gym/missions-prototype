class Postcode < ApplicationRecord
  validates :postcode, uniqueness: true, presence: true, postcode: true
  after_commit :locate!

  def self.postcode!(postcode_string)
    return if postcode_string.blank?

    uk_postcode = UKPostcode.parse(postcode_string)
    return unless uk_postcode.valid?

    Postcode.find_or_create_by(postcode: uk_postcode.to_s)
  end

  def postcode=(str)
    super UKPostcode.parse(str).to_s
  end

  def to_s
    postcode
  end

  def locate!
    return if lat.present? && lng.present?

    geo = Geokit::Geocoders::GoogleGeocoder.geocode("#{postcode}, UK")
    update(lat: geo.lat, lng: geo.lng, geodata: geo.to_hash)
  end

  def point
    @point ||= Geokit::LatLng.new(lat, lng)
  end

  def distance_to(postcode)
    point.distance_to(postcode.point, units: :kms)
  end
end
