# spec/requests/comments_spec.rb
require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:story) { create(:story) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.fetch(:secret_key_base), 'HS256') }

  describe "GET /stories/:story_id/comments" do
    let!(:comments) { create_list(:comment, 3, story: story, user: user) }

    it "returns story comments" do
      get "/stories/#{story.id}/comments", headers: { 'Authorization' => "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].length).to eq(3)
      
      # Verify the structure of a comment
      comment_data = parsed_response['data'].first
      expect(comment_data['type']).to eq('comments')
      expect(comment_data['attributes']).to include(
        'content',
        'created-at',
        'updated-at',
        'user-info'
      )
    end
  end

  describe "POST /stories/:story_id/comments" do
    let(:valid_attributes) { { comment: { content: "Test comment" } } }

    context "with valid attributes" do
      it "creates a new comment" do
        expect {
          post "/stories/#{story.id}/comments",
               params: valid_attributes,
               headers: { 'Authorization' => "Bearer #{token}" }
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']['attributes']['content']).to eq("Test comment")
      end
    end

    context "with invalid attributes" do
      it "does not create a comment" do
        expect {
          post "/stories/#{story.id}/comments",
               params: { comment: { content: "" } },
               headers: { 'Authorization' => "Bearer #{token}" }
        }.not_to change(Comment, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /stories/:story_id/comments/:id" do
    let!(:comment) { create(:comment, user: user, story: story, content: "Original content") }

    context "when user owns the comment" do
      it "updates the comment" do
        patch "/stories/#{story.id}/comments/#{comment.id}",
              params: { comment: { content: "Updated content" } },
              headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']['attributes']['content']).to eq("Updated content")
        expect(comment.reload.content).to eq("Updated content")
      end
    end

    context "when user doesn't own the comment" do
      let(:other_user) { create(:user) }
      let(:other_token) { JWT.encode({ user_id: other_user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.fetch(:secret_key_base), 'HS256') }

      it "returns forbidden status" do
        patch "/stories/#{story.id}/comments/#{comment.id}",
              params: { comment: { content: "Updated content" } },
              headers: { 'Authorization' => "Bearer #{other_token}" }

        expect(response).to have_http_status(:forbidden)
        expect(comment.reload.content).to eq("Original content")
      end
    end
  end

  describe "DELETE /stories/:story_id/comments/:id" do
    let!(:comment) { create(:comment, user: user, story: story) }

    context "when user owns the comment" do
      it "deletes the comment" do
        expect {
          delete "/stories/#{story.id}/comments/#{comment.id}",
                 headers: { 'Authorization' => "Bearer #{token}" }
        }.to change(Comment, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when user doesn't own the comment" do
      let(:other_user) { create(:user) }
      let(:other_token) { JWT.encode({ user_id: other_user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.fetch(:secret_key_base), 'HS256') }

      it "returns forbidden status" do
        expect {
          delete "/stories/#{story.id}/comments/#{comment.id}",
                 headers: { 'Authorization' => "Bearer #{other_token}" }
        }.not_to change(Comment, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context "when user is not authenticated" do
    it "returns unauthorized for protected actions" do
      post "/stories/#{story.id}/comments", params: { comment: { content: "Test comment" } }
      expect(response).to have_http_status(:unauthorized)

      patch "/stories/#{story.id}/comments/1", params: { comment: { content: "Updated content" } }
      expect(response).to have_http_status(:unauthorized)

      delete "/stories/#{story.id}/comments/1"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end