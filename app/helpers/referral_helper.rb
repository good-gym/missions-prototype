module ReferralHelper
  def referral_map(referral)
    content_tag(
      :div,
      "&nbsp;",
      class: "leaflet-map--static w-100 h-75",
      data: { geometry: referral.geometry.to_json, zoom: 12 },
      style: "min-height: 150px;"
    )
  end
end
