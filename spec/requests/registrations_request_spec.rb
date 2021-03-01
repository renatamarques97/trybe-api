# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  describe "POST /create" do
    describe "Valid attributes" do
      let(:valid_attributes_1) { attributes_for(:user) }
      let(:valid_attributes_2) { attributes_for(:user, email: "newuser@email.com") }

      it "do create a new Client" do
        expect {
          post user_registration_path, params: { user: valid_attributes_1 }
        }.to change(User, :count).by(1)
      end

      it "do have a http status 201" do
        post user_registration_path, params: { user: valid_attributes_2 }
        expect(response).to have_http_status(:ok)
      end
    end

    describe "Invalid attributes" do
      let(:invalid_attributes) { attributes_for(:user, displayName: "") }

      it "does not create a new User" do
        expect {
          post user_registration_path, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "do have a http status 422" do
        post user_registration_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
