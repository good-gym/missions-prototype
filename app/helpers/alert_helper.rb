module AlertHelper
  def sentence_of_alerts(alerts)
    alerts.enabled.map { |a| alert_link(a) }.to_sentence.html_safe
  end

  def alert_link(alert)
    link_to(edit_alert_path(alert)) do
      content_tag(:span) do
        concat "#{alert.location} "
        concat content_tag(:small, "(within #{alert.radius}km of #{alert.postcode})").html_safe
      end
    end
  end
end
