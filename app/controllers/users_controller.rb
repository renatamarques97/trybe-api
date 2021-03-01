# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_current_user, only: %i[ destroy ]
  before_action :verify_token, only: %i[ index show destroy ]

  def index
    @users = User.all
    render json: @users.select(:id, :displayName, :email, :image)
  end

  def show
    @user = User.find_by_id(params[:id])

    if @user.present?
      render json: {
        id: @user.id,
        displayName: @user.displayName,
        email: @user.email,
        image: @user.image,
      }, status: :ok
    else
      render json: { message: "User not found" },
        status: :unprocessable_entity
    end
  end

  def destroy
    if @user.nil?
      render json: { message: "User does not exist" },
        status: :unprocessable_entity
    else
      @user.destroy

      render json: {}, status: :no_content
    end
  end

  private

  def set_current_user
    auth = verify_token

    if auth.try(:match, 'Invalid').present?
      return render json: { message: "User invalid" },
        status: :unprocessable_entity
    else
      id = auth.dig(0, "id")
      @user = User.find_by_id(id)
    end
  end

  def verify_token
    token_verifier.call
  end

  def token_verifier
    @_token_verifier ||= ::TokenVerifier.new(request.headers['Authorization'])
  end
end
