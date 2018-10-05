class Postcode < ApplicationRecord
  def to_s
    postcode
  end

  def locate!
    return if lat.present? && lng.present?

    geo = Geokit::Geocoders::GoogleGeocoder.geocode("#{postcode}, UK")
    update(lat: geo.lat, lng: geo.lng, geodata: geo.to_hash)
  end
end
