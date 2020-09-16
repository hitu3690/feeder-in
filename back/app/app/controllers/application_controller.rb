class ApplicationController < ActionController::API
  # protect_from_forgery with: :exception
  # helper_method :current_user
  # include ActionController::Cookies
  # include ActionController::RequestForgeryProtection

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
