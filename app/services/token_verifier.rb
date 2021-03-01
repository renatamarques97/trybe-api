# frozen_string_literal: true

class TokenVerifier
  attr_reader :header

  def initialize(header)
    @header = header
  end

  def call
    if header.present?
      decode_jwt
    else
      'Invalid'
    end
  end

  def decode_jwt
    jwt_payload = JWT
      .decode(header, Rails.application.secrets.secret_key_base)
  end
end
