class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.email}"
    else
      redirect_to '/login'
      flash[:error] = 'Invalid Credentials'
    end
  end
end