module ReferralHelper
  def referral_map(referral)
    content_tag(
      :div,
      "&nbsp;",
      class: "leaflet-map--static w-100 h-100",
      data: { geometry: referral.geometry.to_json, zoom: 12 },
      style: "min-height: 150px;"
    )
  end

  def referrals_map(referrals, center:, &block)
    referral_shapes = referrals.map do |referral|
      referral.geometry[:shapes].first
        .merge(popup: "#referral-map-popup-#{referral.id}")
    end

    geometry = {
      center: center,
      shapes: [
        { type: "marker", point: postcode.point.to_a }
      ] + referral_shapes
    }

    content_tag(:div) do
      concat content_tag(
        :div,
        "&nbsp;",
        class: "leaflet-map--static w-100 h-100",
        data: { geometry: geometry.to_json },
        style: "min-height: 500px;"
      )
      referrals.each do |referral|
        concat content_tag(
          :div, capture(referral, &block),
          id: "referral-map-popup-#{referral.id}",
          class: "d-none"
        )
      end
    end
  end

  def referral_preferences_summary(referral)
    referral
      .preferences.map do |key, value|
        next if value == false

        {
          lifting: "heavy lifting"
        }.with_indifferent_access[key] || key
      end
      .compact.map { |c| content_tag(:strong, c) }.to_sentence.html_safe
  end

  def referral_status(referral, options = {})
    status_class =
      case referral.current_state
      when "approved" then "info"
      when "scheduled" then "warning"
      when "rejected" then "danger"
      else "secondary"
      end

    content_tag(
      :span, referral.current_state.titleize,
      class: "badge badge-#{status_class} #{options[:class]}"
    )
  end
end
