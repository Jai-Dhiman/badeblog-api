require 'rails_helper'

# spec/requests/categories_spec.rb
RSpec.describe "Categories", type: :request do
  describe "GET /categories" do
    before do
      @categories = create_list(:category, 3)
    end

    it "returns all categories" do
      get categories_path
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['data'].length).to eq(@categories.length)
    end

    it "returns the requested category" do
      category = @categories.first
      get category_path(category)
      json_response = JSON.parse(response.body)
      expect(json_response['data']['id'].to_i).to eq(category.id)
    end
  end
end