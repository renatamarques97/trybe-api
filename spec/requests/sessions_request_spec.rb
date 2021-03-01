# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe "POST /create" do
    describe "Valid attributes" do
      let!(:user) { create(:user) }
      let(:auth) { user.generate_jwt }

      it "User successfully logged in" do
        post user_session_path,
          params: { user: { email: user.email , password: user.password }},
          headers: { "Authorization": auth }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
