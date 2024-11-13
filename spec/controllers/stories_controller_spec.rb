require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.fetch(:secret_key_base), 'HS256') }

  before do
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET #index' do
    before do
      create_list(:story, 3, user: user)
    end

    it 'returns all stories' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(3)
    end
  end

  describe 'POST #create' do
    let(:category) { create(:category) }
    let(:valid_attributes) do
      {
          title: 'Test Story',
          content: 'Test Content',
          status: 'draft',
          category_id: category.id
      }
    end

    it 'creates a new story' do
      expect {
        post :create, params: valid_attributes
      }.to change(Story, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
end