module AvailabilityHelper
  def other_runners_available_for(availability, times)
    Availability.near(availability.postcode, availability.radius)
      .not_owned_by(current_user)
      .joins(:time_slots)
      .where(time_slots: { started_at: times })
      .map(&:runner).uniq
  end

  def referrals_available_for(availability, times)
    Referral.near(availability.postcode, availability.radius)
      .joins(:time_slots)
      .where(time_slots: { started_at: times }).uniq
  end

  def preferences_summary(availability)
    availability
      .preferences.map do |key, value|
        next if value == true

        {
          lifting: "heavy lifting"
        }.with_indifferent_access[key] || key
      end
      .compact
      .map { |c| content_tag(:strong, c) }
      .to_sentence(two_words_connector: " or ", last_word_connector: ", or ")
      .html_safe
  end

  def availability_status(availability)
    css_class = {
      confirmed: "badge-success",
      pending: "badge-info",
      waiting: "badge-secondary"
    }[availability.status]

    content_tag(
      :span, availability.status.to_s.capitalize,
      class: "badge #{css_class}"
    )
  end

  def availability_time_slot_status_description(availability)
    css_class = {
      confirmed: "We will be in touch to confirm the details",
      pending: "We will be in touch when a mission is referred",
      waiting: "We need another runner before we can book a mission"
    }[availability.status]
  end

  def availability_time_slot_status(time_slot)
    css_class = {
      confirmed: "badge-success",
      pending: "badge-info",
      waiting: "badge-secondary"
    }[time_slot.status]

    content_tag(
      :span, time_slot.status.to_s.capitalize,
      class: "badge #{css_class}"
    )
  end

  def availability_time_slot_status_description(time_slot)
    css_class = {
      confirmed: "We will be in touch to confirm the details",
      pending: "We will be in touch when a mission is referred",
      waiting: "We need another runner before we can book a mission"
    }[time_slot.status]
  end
end
