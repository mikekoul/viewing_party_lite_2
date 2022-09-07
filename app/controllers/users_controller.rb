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

   private

   def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
end