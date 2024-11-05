require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user, password: 'password123') }

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post :create, params: { email: user.email, password: 'password123' }
        
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('jwt', 'email', 'user_id', 'role')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end