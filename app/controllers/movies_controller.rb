class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    if params[:sort_by]
      @sort = params[:sort_by]
    else
      @sort = session[:sort_by]
    end
    
    if @sort == 'title'
          @movies = @movies.order(@sort)
    elsif @sort == 'release_date'
          @movies = @movies.order(@sort)
    end
    
    if params[:ratings]
      @ratings_filter = params[:ratings].keys
    else
      if session[:ratings]
        @ratings_filter = session[:ratings]
      else
        @ratings_filter = @all_ratings
      end
    end
    
    if @sort!=session[:sort_by]
      session[:sort_by] = @sort
    end
    
    if @ratings_filter!=session[:ratings]
      session[:ratings] = @ratings_filter
    end
    
    @movies = @movies.where('rating in (?)', @ratings_filter)
    
  end
  
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
