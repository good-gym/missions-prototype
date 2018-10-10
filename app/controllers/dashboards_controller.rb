class DashboardsController < ApplicationController
  def referrer
  end

  def runner
    redirect_to(root_path) unless current_user.is_a?(Runner)
  end

  def map
  end

  private

end
