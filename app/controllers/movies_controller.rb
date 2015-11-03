class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :correct_user, only: [:edit, :update, ]
  before_action :authenticate_user!, except: [:index, :show, :upvote, :downvote, :search]

  def search
    if params[:search].present?
      @movies = Movie.search(params[:search])
    else
      @movies = Movie.all #Displays all movies in the database
    end
  end

  def index
    @movies = Movie.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.csv { render text: @movies.to_csv }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movies = Movie.find(params[:id])
    @comments = @movie.comments
  end

  def rating(guide)
    guide.votes.count > 0 ? (guide.upvotes.count / guide.votes.count) : 0
  end

  # GET /movies/new
  def new
    @movie = current_user.movies.build
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = current_user.movies.build(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @movie.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @movie.downvote_by current_user
    redirect_to :back
  end

  def import
    Movie.import(params[:file])
    redirect_to movies_path, notice: "Movies added successfully"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def correct_user
      @movie = current_user.movies.find_by(id: params[:id])
      redirect_to movies_path, notice: "Not authorized to edit this movie" if @movie.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :description, :movie_length, :director, :rating, :year, :image, :remote_image_url)
    end
end
