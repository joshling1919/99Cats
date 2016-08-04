class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    session[:session_token] = user.session_token
  end

  def logout!
    self.current_user.reset_session_token! if self.current_user
    session[:session_token] = nil
  end

  def require_not_signed_in!
    unless current_user.nil?
      flash[:errors] = ["Already signed in"]
      redirect_to cats_url
    end
  end

  def require_current_user!
    redirect_to new_session_url if self.current_user.nil?
  end

end
