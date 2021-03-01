# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:auth) { user.generate_jwt }

  let(:invalid_attributes) do
    attributes_for(:user, displayName: "")
  end

  let(:valid_attributes) do
    attributes_for(:user, email: "example@email.com")
  end

  describe "GET /index" do
    it "renders a successful response" do
      User.create! valid_attributes
      get users_url, headers: { "Authorization": auth }
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get user_url(user), headers: { "Authorization": auth }
      expect(response).to be_successful
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      delete user_url(user), headers: { "Authorization": auth }
      expect(User.count).to be(0)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      delete user_url(user), headers: { "Authorization": auth }
      expect(response).to be_no_content
    end
  end
end
