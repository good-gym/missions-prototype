class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= begin
      return if session[:current_user_id].nil?
      type, id = session[:current_user_id].split("/")
      case type
      when "runners" then Runner.find(id)
      when "referrers" then Referrer.find(id)
      end
    end
  rescue ActiveRecord::RecordNotFound
    session[:current_user_id] = nil
  end

  def redirect_to_settings_if_necessary?
    return unless current_user.is_a?(Runner)
    return if current_user.postcode.present?

    redirect_to(
      edit_dashboards_runner_path(next: request.fullpath),
      notice: "Let's start with your mission preferences"
    )
  end
end
