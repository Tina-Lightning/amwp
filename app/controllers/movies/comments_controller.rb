class Movies::CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @movie = Movie.find(params[:movie_id])
    @comment = current_user.comments.build
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @movie = Movie.find(params[:movie_id])
    @comment = Comment.create(params[:comment].permit(:comment))
    @comment.user_id = current_user.id
    @comment.movie_id = @movie.id

    if @comment.save 
      redirect_to movie_path(@movie)
    else
      render 'new'
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
def destroy
    @movie = Movie.find(params[:movie_id])
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:notice] = "Comment was successfully deleted."
      redirect_to @movie
    else
      flash[:error] = “There was an error”
      render :show
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:comment, :movie_id)
    end
end
