class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      logger.debug(session)
      render :json => { status: 'success', data: current_user }
    else
      render :json => { status: 'error' }
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
