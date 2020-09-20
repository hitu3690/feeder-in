class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  # skip_before_action :verify_authenticity_token, if: :devise_controller?
  # protect_from_forgery with: :null_session
  # protect_from_forgery with: :exception
  # helper_method :current_user
  # include ActionController::Cookies
  # include ActionController::RequestForgeryProtection

  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  # end
end
