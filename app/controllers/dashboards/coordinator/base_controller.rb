class Dashboards::Coordinator::BaseController < ApplicationController
  before_action :verify_admin

  private

  def verify_admin
    return if current_user&.is_a?(Coordinator)

    redirect_to root_url, notice: "You're not authorised to do this."
  end
end
