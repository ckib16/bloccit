class CommentsController < ApplicationController
  
  # def new
  #   @topic = Topic.find(params[:topic_id])
  #   @post = Post.find(params[:post_id])
  #   @comment = Comment.new
  # end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(params.require(:comment).permit (:body)) #Associate comment w/ current user
    @comment.post = @post #Associate the comment to a post
    authorize @comment

    if @comment.save
      flash[:notice] = "Comment was saved."      
    else
      flash[:error] = "There was an error saving the comment."
    end
    redirect_to [@topic, @post]    
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    authorize @comment
    if @comment.destroy
      flash[:notice] = "Comment was deleted successfully"
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error deleting the comment."
      redirect_to [@topic, @post]
    end
  end

end