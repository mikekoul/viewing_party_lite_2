class MoviesController < ApplicationController
   def index
      @user = User.find(params[:user_id])
      params[:query] == 'top_rated'
      @movies = MovieFacade.top_rated_movies
   end
end