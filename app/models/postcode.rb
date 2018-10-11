class Postcode < ApplicationRecord
  validates :postcode, uniqueness: true, presence: true, postcode: true
  after_commit :locate!

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
