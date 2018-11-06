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
      case referral.status
      when :scheduled then "danger"
      else "secondary"
      end

    content_tag(
      :span, referral.status.to_s.titleize,
      class: "badge badge-#{status_class} #{options[:class]}"
    )
  end
end
