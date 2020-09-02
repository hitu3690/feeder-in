class ApplicationController < ActionController::API
  # helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
      # @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
