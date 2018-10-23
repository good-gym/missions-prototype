class Dashboards::RunnersController < ApplicationController
  def show
  end

  def edit
    @runner = current_user
    @runner.default_radius ||= 5
  end

  def update
    if current_user.update(runner_params)
      redirect_to update_redirect_path, notice: "Preferences updated"
    else
      render :settings
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
end
