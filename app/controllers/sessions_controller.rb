class SessionsController < ApplicationController

  before_action :require_not_signed_in!, only: [:new]

  def new
  end

  def create
    @user = User.find_by_credentials(session_params[:username], session_params[:password])

    if @user
      login_user!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["Invalid Login Credentials!"]
      render :new
    end
  end

  def destroy
    self.logout!
    redirect_to cats_url
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
