class Api::V1::SessionsController < ApplicationController
  def create
    logger.debug("~~~~~~~~~~~~~~~~~~~~")
    logger.debug("~~~~~~~~~~~~~~~~~~~~")
    logger.debug(session_params)
    logger.debug("~~~~~~~~~~~~~~~~~~~~")
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      render :json => { status: 'success', data: user }
    else
      render :json => { status: 'error' }
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
