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

  def render_time_picker(locals = {}, &block)
    render(layout: "shared/time_picker", locals: locals, &block)
  end

  def avatar_icon_url(object, size = 50)
    key = object.cache_key.tr("/", "-")
    if object.is_a?(Referrer)
      "https://robohash.org/#{key}"
    else
      "https://api.adorable.io/avatars/#{size}/#{key}"
    end
  end

  def readmore(content)
    content_tag(:div, class: "readmore") do
      concat content_tag(:div, content, class: "readmore__content")
      concat content_tag(:button, "Read more", class: "btn btn-link btn-sm d-block px-0")
    end
  end

  def link_to_collapse(content, target)
    link_to(
      content, "#",
      "aria-controls" => target, "aria-expanded" => "false",
      data: { target: target, toggle: "collapse" }
    )
  end

  def link_to_if_with_block(condition, options, html_options = {}, &block)
    if condition
      link_to(options, html_options, &block)
    else
      content_tag(:span, capture(&block), html_options)
    end
  end

  def link_to_unless_current_with_block(options, html_options = {}, &block)
    link_to_if_with_block(
      !current_page?(options), options, html_options, &block
    )
  end
end
