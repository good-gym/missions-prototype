module ApplicationHelper
  def login_as_button(user, label=nil, options = {})
    button_to(
      label || "Login as #{user.name}",
      sessions_path(id: user.cache_key),
      class: options[:class] || "btn btn-secondary"
    )
  end

  def render_calendar(locals = {}, &block)
    render(layout: "shared/calendar", locals: locals, &block)
  end

  def avatar_icon_url(object, size = 50)
    key = object.cache_key.tr("/", "-")
    if object.is_a?(Referrer)
      "https://robohash.org/#{key}"
    else
      "https://api.adorable.io/avatars/#{size}/#{key}"
    end
  end
end
