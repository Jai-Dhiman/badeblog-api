require 'rails_helper'

RSpec.describe "Stories API", type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:category) { create(:category) }

  describe "GET /stories" do
    context "when stories exist" do
      before do
        create_list(:story, 3, :published, user: admin_user)
        create(:story, :published, user: admin_user, title: "Special Story")
        create(:story, status: 'draft', user: admin_user)
      end

      it "returns only published stories" do
        get stories_path
        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(4)
        expect(json_response['data'].map { |s| s['attributes']['status'] }.uniq).to eq(['published'])
      end

      it "returns stories in correct order" do
        get stories_path
        expect(response).to have_http_status(:ok)
        dates = json_response['data'].map { |s| s['attributes']['created-at'] }
        expect(dates).to eq(dates.sort.reverse)
      end

      it "includes category and user relationships" do
        get stories_path
        story_data = json_response['data'].first
        expect(story_data['relationships']).to include('category', 'user')
      end
    end

    context "when no stories exist" do
      it "returns an empty array" do
        get stories_path
        expect(response).to have_http_status(:ok)
        expect(json_response['data']).to be_empty
      end
    end
  end

  describe "GET /stories/:id" do
    let(:story) { create(:story, :published, user: admin_user) }

    context "when the story exists" do
      it "returns the requested story" do
        get story_path(story)
        expect(response).to have_http_status(:ok)
        expect(json_response['data']['id'].to_s).to eq(story.id.to_s)
      end
    end

    context "when the story doesn't exist" do
      it "returns not found" do
        get story_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /stories" do
    let(:valid_attributes) do
      {
        story: {
          title: "New Story",
          content: "Story content",
          status: "draft",
          category_id: category.id
        }
      }
    end

    context "when user is admin" do
      it "creates a new story" do
        expect {
          post stories_path, 
               params: valid_attributes, 
               headers: auth_headers(admin_user)
        }.to change(Story, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      context "with invalid attributes" do
        it "returns unprocessable entity status" do
          post stories_path, 
               params: { story: { title: nil } }, 
               headers: auth_headers(admin_user)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is not admin" do
      it "returns forbidden status" do
        post stories_path, 
             params: valid_attributes, 
             headers: auth_headers(regular_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /stories/:id" do
    let(:story) { create(:story, user: admin_user) }
    let(:new_attributes) do
      {
        story: {
          title: "Updated Title"
        }
      }
    end

    context "when user is admin" do
      it "updates the story" do
        patch story_path(story), 
              params: new_attributes, 
              headers: auth_headers(admin_user)
        expect(response).to have_http_status(:ok)
        expect(story.reload.title).to eq("Updated Title")
      end
    end

    context "when user is not admin" do
      it "returns forbidden status" do
        patch story_path(story), 
              params: new_attributes, 
              headers: auth_headers(regular_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /stories/:id" do
    let!(:story) { create(:story, user: admin_user) }

    context "when user is admin" do
      it "soft deletes the story" do
        expect {
          delete story_path(story), headers: auth_headers(admin_user)
        }.to change { Story.count }.by(-1)
        .and change { Story.with_deleted.count }.by(0)
        
        expect(response).to have_http_status(:no_content)
        expect(story.reload.deleted_at).to be_present
      end
    end

    context "when user is not admin" do
      it "returns forbidden status" do
        delete story_path(story), headers: auth_headers(regular_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /stories/drafts" do
    before do
      create_list(:story, 2, status: 'draft', user: admin_user)
      create(:story, :published, user: admin_user)
    end

    context "when user is admin" do
      it "returns only draft stories" do
        get drafts_stories_path, headers: auth_headers(admin_user)
        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(2)
        expect(json_response['data'].map { |s| s['attributes']['status'] }.uniq).to eq(['draft'])
      end
    end

    context "when user is not admin" do
      it "returns forbidden status" do
        get drafts_stories_path, headers: auth_headers(regular_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end