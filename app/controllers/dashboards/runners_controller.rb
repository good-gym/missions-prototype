class Dashboards::RunnersController < ApplicationController
  before_action :redirect_to_settings_if_necessary?, only: :show
  before_action :redirect_to_setup_alerts_if_necessary?, only: :show

  def show
    @reservations = current_user.reservations.upcoming
  end

  def edit
    @runner = current_user
    @runner.default_radius ||= 5
  end

  def update
    if current_user.update(runner_params)
      redirect_to update_redirect_path, notice: "Preferences updated"
    else
      render :edit
    end
  end

  private

  def runner_params
    params.require(:runner)
      .permit(:postcode_str, :default_radius, preferences: {})
  end

  def update_redirect_path
    paths = [listings_path, new_availability_path, todo_path]
    paths.include?(params[:next]) ? params[:next] : root_path
  end

  def redirect_to_settings_if_necessary?
    return unless current_user.is_a?(Runner)
    return if current_user.updated_at > current_user.created_at

    redirect_to(
      edit_dashboards_runner_path,
      notice: "Let's start with your mission preferences"
    )
  end

  def redirect_to_setup_alerts_if_necessary?
    return unless current_user.is_a?(Runner)
    return if current_user.alerts.any?

    redirect_to(
      new_alert_path,
      notice: "Let's setup your default location"
    )
  end
end
