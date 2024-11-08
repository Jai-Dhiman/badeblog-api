require 'rails_helper'

RSpec.describe "Stories", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.fetch(:secret_key_base), 'HS256') }

  describe "GET /api/v1/stories" do
    before do
      create_list(:story, 3, user: user)
    end

    it "returns all stories" do
      get "/api/v1/stories", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(3)
    end
  end

  describe "POST /api/v1/stories" do
    let(:category) { create(:category) }
    let(:valid_attributes) do
      {
        story: {
          title: 'Test Story',
          content: 'Test Content',
          status: 'draft',
          category_id: category.id
        }
      }
    end

    it "creates a new story" do
      expect {
        post "/api/v1/stories",
             params: valid_attributes,
             headers: { 'Authorization' => "Bearer #{token}" }
      }.to change(Story, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
end