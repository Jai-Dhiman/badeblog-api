require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:story) }
  end

  describe 'creation' do
    let(:user) { create(:user) }
    let(:story) { create(:story) }
    
    it 'can be created with valid attributes' do
      comment = build(:comment, user: user, story: story)
      expect(comment).to be_valid
    end
  end
end