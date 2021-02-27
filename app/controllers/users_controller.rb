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
    auth = decode_jwt(request.headers['Authorization'])

    if auth.try(:match, 'Invalid').present?
      return auth
    else
      id = auth.dig(0, "id")
      @user = User.find_by_id(id)
    end
  end

  def decode_jwt(token)
    begin
      jwt_payload = JWT
        .decode(token, Rails.application.secrets.secret_key_base)
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      return render json: { message: "Invalid or expired token" },
        status: :unprocessable_entity
    end
  end

  def verify_token
    if request.headers['Authorization'].present?
      decode_jwt(request.headers['Authorization'])
    else
      return render json: { message: "Invalid or expired token" },
        status: :unprocessable_entity
    end
  end
end
