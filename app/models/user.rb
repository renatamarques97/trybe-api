# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :displayName, presence: true
  validates :email, presence: true
  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def generate_jwt
    JWT.encode({ id: id, exp: 7.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end
end
