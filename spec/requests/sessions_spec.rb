require 'rails_helper'

RSpec.describe "Sessions API", type: :request do
  describe "POST /sessions" do
    let(:user) { create(:user, password: 'password123') }

    context "with valid credentials" do
      it "returns JWT token and user info" do
        post sessions_path, params: {
          email: user.email,
          password: 'password123'
        }
        
        expect(response).to have_http_status(:created)
        expect(json_response).to include('jwt', 'email', 'user_id', 'role')
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized status" do
        post sessions_path, params: {
          email: user.email,
          password: 'wrong_password'
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end