# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/posts", type: :request do
  let(:user) { create(:user) }
  let(:auth) { user.generate_jwt }

  let(:invalid_attributes) do
    attributes_for(:post, title: "", user_id: user.id)
  end

  let(:valid_attributes) do
    attributes_for(:post, user_id: user.id)
    # you won't need to pass user id when requesting to the endpoint
  end

  describe "GET /index" do
    it "renders a successful response" do
      Post.create! valid_attributes
      get posts_url, headers: { "Authorization": auth }
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      post = Post.create! valid_attributes
      get post_url(post), headers: { "Authorization": auth }
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Post" do
        expect {
          post posts_url, params: { post: valid_attributes }, headers: { "Authorization": auth }
        }.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        post posts_url, params: { post: valid_attributes }, headers: { "Authorization": auth }
        expect(response).to be_created
      end
    end

    context "with invalid parameters" do
      it "does not create a new Post" do
        expect {
          post posts_url, params: { post: invalid_attributes }, headers: { "Authorization": auth }
        }.to change(Post, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post posts_url, params: { post: invalid_attributes }, headers: { "Authorization": auth }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          "title": "edited",
          "content": "test",
          "user_id": user.id
        }
      end

      it "updates the requested post" do
        post = Post.create! valid_attributes
        patch post_url(post), params: { post: new_attributes }, headers: { "Authorization": auth }
        post.reload
        expect(post.title).to eq("edited")
      end

      it "redirects to the post" do
        post = Post.create! valid_attributes
        patch post_url(post), params: { post: new_attributes }, headers: { "Authorization": auth }
        post.reload
        expect(response).to be_successful
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        post = Post.create! valid_attributes
        patch post_url(post), params: { post: invalid_attributes }, headers: { "Authorization": auth }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested post" do
      post = Post.create! valid_attributes
      expect {
        delete post_url(post), headers: { "Authorization": auth }
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      post = Post.create! valid_attributes
      delete post_url(post), headers: { "Authorization": auth }
      expect(response).to be_no_content
    end
  end
end
