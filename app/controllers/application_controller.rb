class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= begin
      return if session[:current_user_id].nil?
      type, id = session[:current_user_id].split("/")
      case type
      when "runners" then Runner.find(id)
      end
    end
  rescue ActiveRecord::RecordNotFound
    session[:current_user_id] = nil
  end
end
