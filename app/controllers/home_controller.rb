class HomeController < ApplicationController
  def index
    if current_user.is_a?(Runner)
      redirect_to runner_dashboards_path
    end
  end
end
