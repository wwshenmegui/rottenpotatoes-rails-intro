class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    @sort_method=params[:sort_by]
    
    #If there is no param and session is not nil, we need to redirect
    need_redirect=false
    
    #Determine how to sort
    if @sort_method==nil
      @sort_method=session[:sort_by]
      if @sort_method!=params[:sort_by]
        need_redirect=true
      end
    end
    session[:sort_by]=@sort_method
    
    #Determine what to filter
    @selected_ratings=params[:ratings]
    if(@selected_ratings==nil||@selected_ratings.empty?)
      @selected_ratings=session[:ratings]
      if @selected_ratings==nil
        @selected_ratings=@all_ratings
      else
        need_redirect=true
      end
    else
      if(@selected_ratings.kind_of?(Hash))
        @selected_ratings = @selected_ratings.keys
      end
    end
    session[:ratings]=@selected_ratings
    
    if need_redirect
      flash.keep
      redirect_to movies_path(:sort_by=>@sort_method,:ratings=>@selected_ratings)
    end
    
    #Determine how to sort
    @movies = Movie.find_by_ratings(@selected_ratings).order(@sort_method)
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

end
