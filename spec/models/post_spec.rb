require 'rails_helper'

RSpec.describe Post, type: :model do
  # En base al modelo de test propuesto para el modelo User,
  # implementar los tests para el modelo Post.
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build(:post)).to be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    # https://github.com/thoughtbot/shoulda-matchers#activerecord-matchers
  end

  describe 'Presence validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
  end

  describe 'Uniqueness validations' do
    subject { create(:post) }
    it { should validate_uniqueness_of(:title) }
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
  end
end
