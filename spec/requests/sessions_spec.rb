require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /sessions" do
    let(:user) { create(:user, password: 'password123') }

    it "creates a session with valid credentials" do
      post "/sessions", params: {
        email: user.email,
        password: 'password123'
      }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('jwt', 'email')
    end

    it "fails with invalid credentials" do
      post "/sessions", params: {
        email: user.email,
        password: 'wrong_password'
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end