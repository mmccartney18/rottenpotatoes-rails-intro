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
       #Part 3:
   #for each of these two options (sort_by. ratings)
   #1. if the params[]hash gives explicit values for those override them in session
   #2. otherwise if they are stored preferences in the sessions. use those to fill in params
   #3 if neither params or nor sessions are availible, apply defaults

   params.permit!
    @all_ratings = Movie.all_ratings
    #makes check boxes appear if appeared (clicked) true
    @ratings = params[:ratings]
    #part 3 
    #redirect is like refresh
    redirect = false
    

    if params[:sort_by]
        @sort_by = params[:sort_by]
        session[:sort_by] = params[:sort_by]
    elsif session[:sort_by]
        @sort_by = session[:sort_by]
        redirect = true
    else
        @sort_by = nil
    end

    if params[:commit] == "Refresh" and params[:ratings].nil?
        @ratings = nil
        session[:ratings] = nil
    elsif params[:ratings]
        @ratings = params[:ratings]
        session[:ratings] = params[:ratings]
    elsif session[:ratings]
        @ratings = session[:ratings]
        redirect = true
    else 
        @ratings = nil
    end

    if redirect
        flash.keep
        redirect_to movies_path :sort_by=>@sort_by, :ratings=>@ratings
    end
    
    #@movies = Movie.all
    #@sort_by = params[:sort_by]
    #@ratings = params[:ratings]
    #params.permit!
    if @ratings and @sort_by
        #@movies = Movie.where(:rating => params[:ratings].keys).order[:sort_by]
       # @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort_by])
        @movies = Movie.where(:rating => @ratings.keys).order(params[:sort_by])
        #@movies = Movie.where(:rating => params[:ratings].keys).find(:all, :order =>(params[:sort_by])
        #@movies = Movie.where(:rating => params[:ratings].keys).find(:all, :order(sort_by)
    elsif @ratings 
        #@movies = Movie.where(:rating => params[:ratings].keys)
        @movies = Movie.where(:rating => @ratings.keys)
    elsif @sort_by
        @movies = @movies.order(@sort_by)
    else
        @movies = Movie.all
    end 
    
    if !@ratings
        @ratings = Hash.new
    end

   # @movies = Movie.all
    #if params[:ratings]
    #    @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort_by])
    #end
   # @sort_by = params[:sort_by]
   # @all_ratings = Movie.all_ratings
   # @set_ratings = params[:ratings]
   # if !@set_ratings
    #    @set_ratings = Hash.new
   # end

    #@sort_by = params[:sort_by]
    #@sort_column = params[:sort_by]
    #@movies = @movies.order(@sort_column)
    #@all_ratings = Movie.all_ratings
    
    #@current_ratings = params[:ratings]
    #if !params = [:ratings].nil?
        #@movies = Movie.where(rating: @current_ratings.keys)
    #end

    #@set_ratings = params[:ratings]
   #if !@set_ratings
    #@set_ratings = Hash.new
   #end

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

