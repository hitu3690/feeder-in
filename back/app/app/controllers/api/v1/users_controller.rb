class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render :json => { status: 'success', data: user }
    else
      render :json => { status: 'error' }
    end
  end

  def show
    current_user = User.find_by(id: params[:id])
    session[:user_id] = current_user.id
    # user = User.find(1)
    # current_user = User.find_by(id: session[:user_id])
    logger.debug(session)
    logger.debug(current_user == nil)
    logger.debug("~~~~~~~~~~~~~~~~~~~~")
    # feeds = current_user.feeds.order(sort_id: :ASC)
    # current_user = User.find_by(id: params[:id])
    if current_user
      feeds = current_user.feeds.order(sort_id: :ASC)
      render :json => { status: 'success', data: feeds }
    else
      render :json => { status: 'error', data: "ログインしてください" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
