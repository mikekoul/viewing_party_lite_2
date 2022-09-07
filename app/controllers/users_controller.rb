class UsersController < ApplicationController
   def new
   end

   def create
      user = User.create(user_params)
      if user.save
         redirect_to user_path(user.id)
         flash[:success] = "Welcome, #{user.email}"
      else
         redirect_to "/register"
         flash[:error] = user.errors.full_messages    
      end   
   end

   def show
      @user = User.find(params[:id])
   end

   def login_form
   end

   def login_user
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
         redirect_to user_path(user.id)
         flash[:success] = "Welcome, #{user.email}"
      else
         redirect_to '/login'
         flash[:error] = 'Invalid Credentials'
      end
   end

   private

   def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
end