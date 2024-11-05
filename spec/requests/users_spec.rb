require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /api/v1/users" do
    let(:valid_attributes) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          name: 'Test User'
        }
      }
    end

    it "creates a new user" do
      expect {
        post "/api/v1/users", params: valid_attributes
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
end