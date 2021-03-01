class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  before_action :set_current_user, only: %i[ create ]
  before_action :verify_token, only: %i[ index show create update destroy ]

  def index
    @posts = Post.all
    render json: @posts.select(:id, :title, :content, :user_id)
  end

  def show
    if @post.present?
      render json: {
        id: @post.id,
        title: @post.title,
        content: @post.content,
        user_id: @post.user_id,
      }, status: :ok
    else
      render json: { message: "Post not found" },
        status: :unprocessable_entity
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @user.id

    if @post.save
      render json: {
        title: @post.title,
        content: @post.content,
        user_id: @post.user_id
      }, status: :created
    else
      render json: { message: "Invalid attributes" }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: { title: @post.title, content: @post.content }, status: :ok
    else
      render json: { message: "Invalid attributes" }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy

    render json: {}, status: :no_content
  end

  private

  def set_current_user
    auth = token_verifier.call

    if auth.try(:match, 'Invalid').present?
      return render json: { message: "Token invalid or expired" },
        status: :unprocessable_entity
    else
      id = auth.dig(0, "id")
      @user = User.find_by_id(id)
    end
  end

  def verify_token
    if token_verifier.call.try(:match, 'Invalid').present?
      return render json: { message: "Token invalid or expired" },
        status: :unprocessable_entity
    else
      token_verifier.call
    end
  end

  def token_verifier
    @_token_verifier ||= ::TokenVerifier.new(request.headers['Authorization'])
  end

  def set_post
    @post = Post.find_by_id(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end
end
