class SessionsController < Devise::SessionsController
  before_action :process_token

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
      begin
        jwt_payload = JWT
          .decode(request.headers['Authorization']
          .split(' ')[1].remove('"'), Rails.application.secrets.secret_key_base)
          .first
        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def signed_in?
    binding.pry
    current_user.present?
  end

  def current_user
    binding.pry
    @current_user ||= super || User.find(@current_user_id)
  end

  def sign_in_params
    params.permit(:email, :password, :displayName, :image)
  end
end
