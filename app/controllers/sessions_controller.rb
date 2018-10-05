class SessionsController < ApplicationController
  def create
    session[:current_user_id] = params[:id]
    redirect_to root_path
  end
end
