require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:story) { create(:story) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.fetch(:secret_key_base), 'HS256') }

  describe "GET /api/v1/stories/:story_id/comments" do
    before do
      create_list(:comment, 3, story: story, user: user)
    end

    it "returns story comments" do
      get "/api/v1/stories/#{story.id}/comments", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(3)
    end
  end
end