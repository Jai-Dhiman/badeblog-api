RSpec.describe "Categories API", type: :request do
  describe "GET /categories" do
    before do
      create_list(:category, 3)
    end

    it "returns all categories" do
      get categories_path
      expect(response).to have_http_status(:ok)
      expect(json_response['data'].length).to eq(3)
    end
  end

  describe "GET /categories/:id" do
    let(:category) { create(:category) }

    it "returns the requested category" do
      get category_path(category)
      expect(response).to have_http_status(:ok)
      expect(json_response['data']['id'].to_s).to eq(category.id.to_s)
    end

    context "when category doesn't exist" do
      it "returns not found status" do
        get category_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /categories/:id/stories" do
    let(:category) { create(:category) }
    
    before do
      create_list(:story, 2, :published, category: category)
      create(:story, status: 'draft', category: category)
    end

    it "returns only published stories for the category" do
      get stories_category_path(category)
      expect(response).to have_http_status(:ok)
      expect(json_response['data'].length).to eq(2)
      expect(json_response['data'].map { |s| s['attributes']['status'] }.uniq).to eq(['published'])
    end
  end
end