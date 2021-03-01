# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  before_action :process_token, only: %i[ create ]

  def create
    user = User.find_by_email(sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      token = current_user.generate_jwt
      render json: token.to_json
    else
      render json: { errors: { 'email or password' => ['is invalid'] } },
        status: :unprocessable_entity
    end
  end

  private

  def process_token
    if request.headers['Authorization'].present?
      decode_token
    else
      render json: { message: "Token cannot be empty" }, status: :unprocessable_entity
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def signed_in?
    current_user.present?
  end

  def decode_token
    begin
      jwt_payload = token_verifier.decode_jwt.first
      @current_user_id = jwt_payload['id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      return render json: { message: "Invalid or expired token" },
        status: :unprocessable_entity
    end
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def sign_in_params
    params.require(:user).permit(:email, :password, :displayName, :image)
  end

  def token_verifier
    @_token_verifier ||= ::TokenVerifier.new(request.headers['Authorization'])
  end
end
