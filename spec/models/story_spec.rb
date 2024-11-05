require 'rails_helper'

RSpec.describe Story, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[draft published]) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:comments) }
    it { should have_one_attached(:photo) }
    it { should have_rich_text(:content) }
  end

  describe 'soft delete' do
    it 'can be soft deleted' do
      story = create(:story)
      expect { story.destroy }.to change { story.deleted_at }.from(nil)
      expect(Story.count).to eq(0)
      expect(Story.with_deleted.count).to eq(1)
    end
  end
end