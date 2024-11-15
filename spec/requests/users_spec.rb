require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "POST /users" do
    let(:valid_attributes) do
      {
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123",
        name: "Test User",
        role: "user"
      }
    end

    context "with valid attributes" do
      it "creates a new user" do
        expect {
          post users_path, params: valid_attributes
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response['user']).to include('email', 'name')
        expect(json_response).to include('token')
      end
    end

    context "with invalid attributes" do
      it "returns unprocessable entity status" do
        post users_path, params: valid_attributes.merge(email: "")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /users/:id" do
    let(:user) { create(:user) }

    context "when authenticated" do
      it "returns user information" do
        get user_path(user), headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        
        expect(json_response['id']).to eq(user.id)
        expect(json_response['email']).to eq(user.email)
        expect(json_response['name']).to eq(user.name)
        expect(json_response['role']).to eq(user.role)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        get user_path(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:new_attributes) do
      {
        name: "Updated Name"
      }
    end

    context "when authenticated" do
      it "updates the user" do
        patch user_path(user),
              params: new_attributes,
              headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        expect(user.reload.name).to eq("Updated Name")
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        patch user_path(user), params: new_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end