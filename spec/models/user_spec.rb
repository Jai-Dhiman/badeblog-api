require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_inclusion_of(:role).in_array(%w[admin user]) }
  end

  describe 'associations' do
    it { should have_many(:stories) }
    it { should have_many(:comments) }
  end

  describe '#admin?' do
    it 'returns true when role is admin' do
      user = build(:user, role: 'admin')
      expect(user.admin?).to be true
    end

    it 'returns false when role is user' do
      user = build(:user, role: 'user')
      expect(user.admin?).to be false
    end
  end
end