module ApplicationHelper
  def login_as_button(user)
    button_to(
      "Login as #{user.name}",
      sessions_path(id: user.cache_key),
      class: "btn btn-secondary"
    )
  end

  def render_calendar(locals = {}, &block)
    render(layout: "shared/calendar", locals: locals, &block)
  end
end
