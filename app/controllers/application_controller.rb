class ApplicationController < ActionController::Base
  helper_method :current_user, :current_default, :current_registered

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

end
