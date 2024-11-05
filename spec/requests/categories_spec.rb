require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /api/v1/categories" do
    before do
      create_list(:category, 3)
    end

    it "returns all categories" do
      get "/api/v1/categories"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(3)
    end
  end

  describe "GET /api/v1/categories/:id" do
    let(:category) { create(:category) }

    it "returns the requested category" do
      get "/api/v1/categories/#{category.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(category.id)
    end
  end
end