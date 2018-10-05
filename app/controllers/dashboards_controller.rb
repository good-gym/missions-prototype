class DashboardsController < ApplicationController
  def runner
    redirect_to(root_path) unless current_user.is_a?(Runner)
  end
end
