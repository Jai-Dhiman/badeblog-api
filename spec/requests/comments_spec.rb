# spec/requests/comments_spec.rb
RSpec.describe "Comments API", type: :request do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:story) { create(:story, :published, user: admin_user) }

  describe "GET /stories/:story_id/comments" do
    before do
      create_list(:comment, 3, story: story, user: user)
    end

    it "returns all comments for the story" do
      get story_comments_path(story)
      expect(response).to have_http_status(:ok)
      expect(json_response['data'].length).to eq(3)
    end
  end

  describe "POST /stories/:story_id/comments" do
    let(:valid_attributes) do
      {
        comment: {
          content: "Great story!"
        }
      }
    end

    context "when user is authenticated" do
      it "creates a new comment" do
        expect {
          post story_comments_path(story),
               params: valid_attributes,
               headers: auth_headers(user)
        }.to change(Comment, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      context "with invalid attributes" do
        it "returns unprocessable entity status" do
          post story_comments_path(story),
               params: { comment: { content: "" } },
               headers: auth_headers(user)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        post story_comments_path(story), params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /stories/:story_id/comments/:id" do
    let(:comment) { create(:comment, user: user, story: story) }
    let(:new_attributes) do
      {
        comment: {
          content: "Updated comment"
        }
      }
    end

    context "when user owns the comment" do
      it "updates the comment" do
        patch story_comment_path(story, comment),
              params: new_attributes,
              headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        expect(comment.reload.content).to eq("Updated comment")
      end
    end

    context "when user doesn't own the comment" do
      let(:other_user) { create(:user) }

      it "returns forbidden status" do
        patch story_comment_path(story, comment),
              params: new_attributes,
              headers: auth_headers(other_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /stories/:story_id/comments/:id" do
    let!(:comment) { create(:comment, user: user, story: story) }

    context "when user owns the comment" do
      it "deletes the comment" do
        expect {
          delete story_comment_path(story, comment),
                 headers: auth_headers(user)
        }.to change(Comment, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when user doesn't own the comment" do
      let(:other_user) { create(:user) }

      it "returns forbidden status" do
        delete story_comment_path(story, comment),
               headers: auth_headers(other_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end